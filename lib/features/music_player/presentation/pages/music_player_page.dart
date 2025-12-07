import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_pallete.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_event.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

/// ----------------------------------------------------------------------------
/// COMPONENT: MusicPlayerPage (Bottom Sheet Implementation)
/// ROLE: UI Presentation (Pillar 3)
/// DESIGN: Spotify-inspired "Now Playing" interface with dynamic gradient background.
/// ----------------------------------------------------------------------------
class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Color? _dominantColor;
  int? _lastSongId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MusicPlayerBloc, MusicPlayerState, SongEntity?>(
      selector: (state) => state.currentSong,
      builder: (context, song) {
        if (song == null) {
          return const SizedBox.shrink();
        }

        // Trigger color extraction ONLY when song changes
        if (_lastSongId != song.id) {
          _lastSongId = song.id;
          _updatePalette(song.id);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuart, // Physics-based smoothing
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _dominantColor ?? AppPallete.gradientTop,
                const Color(0xFF121212), // Deep black at bottom
              ],
            ),
          ),
          child: Scaffold(
            // Transparent scaffold to allow gradient to show through
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(context),
            // Use SafeArea to avoid overlap with status bar/notch, but keep gradient full screen
            body: SafeArea(
              bottom: false, // Allow bottom to go behind nav bar if needed
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Dynamic Spacer using Flex to adapt to screen height
                    const Spacer(flex: 1),

                    // 1. ARTWORK (Visual Centerpiece)
                    _ArtworkDisplay(song: song),

                    const Spacer(flex: 1),

                    // 2. META INFO (Title, Artist, Like)
                    _TrackInfoRow(song: song),

                    const SizedBox(height: 20),

                    // 3. PROGRESS (Interactive Physics)
                    const _InterpolatedProgressBar(),

                    const SizedBox(height: 10),

                    // 4. CONTROLS (Main Interaction)
                    const _PlayerControls(),

                    const Spacer(flex: 1),

                    // 5. FOOTER (Secondary Actions)
                    const _BottomActionRow(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- LOGIC: Dynamic Color Extraction ---
  Future<void> _updatePalette(int songId) async {
    try {
      final OnAudioQuery audioQuery = OnAudioQuery();
      final Uint8List? artBytes = await audioQuery.queryArtwork(
        songId,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 1000,
      );

      if (artBytes != null) {
        final PaletteGenerator palette =
            await PaletteGenerator.fromImageProvider(
          MemoryImage(artBytes),
          maximumColorCount: 5,
        );
        if (mounted) {
          setState(() {
            // Prioritize dark muted/vibrant colors for Spotify-like look
            Color? selected = palette.darkMutedColor?.color ??
                palette.darkVibrantColor?.color;

            if (selected == null && palette.dominantColor != null) {
              final hsl = HSLColor.fromColor(palette.dominantColor!.color);
              // Darken it if it's too light
              selected =
                  hsl.withLightness((hsl.lightness - 0.2).clamp(0.1, 0.5)).toColor();
            }

            _dominantColor = selected;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _dominantColor = null; // Revert to default
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _dominantColor = null);
    }
  }

  // --- WIDGET: Custom App Bar ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: const [
          Text(
            "PLAYING FROM YOUR LIBRARY",
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Liked Songs", // Dynamic context could go here
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {}, // Context menu action
        ),
      ],
    );
  }
}

/// ----------------------------------------------------------------------------
/// WIDGET: Artwork Display
/// ----------------------------------------------------------------------------
class _ArtworkDisplay extends StatelessWidget {
  final SongEntity song;
  const _ArtworkDisplay({required this.song});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16,
          ), // Rounder corners (Spotify style)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            nullArtworkWidget: Container(
              color: Colors.grey[900],
              child: const Icon(Icons.music_note, size: 80, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------------
/// WIDGET: Interpolated Progress Bar
/// Uses a local Timer to smoothly update the slider between Bloc updates.
/// ----------------------------------------------------------------------------
class _InterpolatedProgressBar extends StatefulWidget {
  const _InterpolatedProgressBar();

  @override
  State<_InterpolatedProgressBar> createState() =>
      _InterpolatedProgressBarState();
}

class _InterpolatedProgressBarState extends State<_InterpolatedProgressBar> {
  double _currentValue = 0.0;
  double _maxValue = 1.0;
  Timer? _timer;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    // Start the interpolation timer
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateProgress();
    });
  }

  void _updateProgress() {
    if (_isDragging || !mounted) return;

    final state = context.read<MusicPlayerBloc>().state;
    if (state.isPlaying) {
      setState(() {
        // Increment by 100ms (0.1s)
        _currentValue += 0.1;
        if (_currentValue > _maxValue) _currentValue = _maxValue;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicPlayerBloc, MusicPlayerState>(
      listenWhen: (prev, curr) =>
          prev.position != curr.position ||
          prev.duration != curr.duration ||
          prev.isPlaying != curr.isPlaying,
      listener: (context, state) {
        if (_isDragging) return;

        setState(() {
          _maxValue = state.duration.inSeconds.toDouble();
          // Sync with the source of truth if drift is significant (>1.5s) or paused
          final diff =
              (state.position.inSeconds.toDouble() - _currentValue).abs();
          if (diff > 1.5 || !state.isPlaying) {
            _currentValue = state.position.inSeconds.toDouble();
          }
        });
      },
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              min: 0,
              max: _maxValue,
              value: _currentValue.clamp(0.0, _maxValue),
              onChanged: (val) {
                setState(() {
                  _isDragging = true;
                  _currentValue = val;
                });
              },
              onChangeEnd: (val) {
                _isDragging = false;
                context.read<MusicPlayerBloc>().add(
                  MusicPlayerEvent.seek(Duration(seconds: val.toInt())),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(Duration(seconds: _currentValue.toInt())),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                _formatDuration(Duration(seconds: _maxValue.toInt())),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// ----------------------------------------------------------------------------
/// WIDGET: Track Info (Title + Artist + Like)
/// ----------------------------------------------------------------------------
class _TrackInfoRow extends StatelessWidget {
  final SongEntity song;
  const _TrackInfoRow({required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text Info (Flexible to prevent overflow)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.title, // "YABA LEH?"
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                song.artist, // "Marwan Moussa"
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Like Action (Placeholder for now)
        IconButton(
          icon: const Icon(
            Icons.check_circle,
            color: AppPallete.primaryGreen,
            size: 28,
          ),
          onPressed: () {}, // Toggle Like
        ),
      ],
    );
  }
}

/// ----------------------------------------------------------------------------
/// WIDGET: Player Controls (Shuffle, Prev, Play, Next, Repeat)
/// ----------------------------------------------------------------------------
class _PlayerControls extends StatelessWidget {
  const _PlayerControls();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      // Listen to shuffle/loop states as well
      buildWhen: (prev, curr) =>
          prev.isPlaying != curr.isPlaying ||
          prev.isShuffling != curr.isShuffling ||
          prev.isLooping != curr.isLooping,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Shuffle
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: state.isShuffling
                    ? AppPallete.primaryGreen
                    : Colors.white,
                size: 24,
              ),
              onPressed: () {
                // Implement shuffle toggle event if exists
              },
            ),

            // Previous
            IconButton(
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                context.read<MusicPlayerBloc>().add(
                  const MusicPlayerEvent.playPreviousSong(),
                );
              },
            ),

            // Play/Pause (Circle Design)
            GestureDetector(
              onTap: () {
                if (state.isPlaying) {
                  context.read<MusicPlayerBloc>().add(
                    const MusicPlayerEvent.pause(),
                  );
                } else {
                  context.read<MusicPlayerBloc>().add(
                    const MusicPlayerEvent.resume(),
                  );
                }
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black, // Dark icon on white button
                  size: 32,
                ),
              ),
            ),

            // Next
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
              onPressed: () {
                context.read<MusicPlayerBloc>().add(
                  const MusicPlayerEvent.playNextSong(),
                );
              },
            ),

            // Repeat
            IconButton(
              icon: Icon(
                Icons.repeat,
                color: state.isLooping ? AppPallete.primaryGreen : Colors.white,
                size: 24,
              ),
              onPressed: () {
                // Implement loop toggle event if exists
              },
            ),
          ],
        );
      },
    );
  }
}

/// ----------------------------------------------------------------------------
/// WIDGET: Bottom Action Row (Device, Share, Menu)
/// ----------------------------------------------------------------------------
class _BottomActionRow extends StatelessWidget {
  const _BottomActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.devices,
            color: AppPallete.primaryGreen,
            size: 20,
          ),
          onPressed: () {},
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}