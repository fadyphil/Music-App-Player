import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/music_player_bloc.dart';
import '../bloc/music_player_event.dart';
import '../bloc/music_player_state.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: AppPallete.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Now Playing",
          style: TextStyle(color: AppPallete.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppPallete.gradientTop, AppPallete.backgroundColor],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. ART & INFO (Stable - No Flicker)
            _ArtworkAndTitle(),

            SizedBox(height: 30),

            // 2. SLIDER (Updates constantly)
            _SmoothProgressBar(),

            SizedBox(height: 20),

            // 3. CONTROLS (Updates on click)
            _PlayerControls(),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET 1: Artwork & Text
// Rebuilds ONLY when the song changes.
// -----------------------------------------------------------------------------
class _ArtworkAndTitle extends StatelessWidget {
  const _ArtworkAndTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MusicPlayerBloc, MusicPlayerState, SongEntity?>(
      selector: (state) => state.currentSong,
      builder: (context, song) {
        if (song == null) return const SizedBox.shrink();

        return Column(
          children: [
            // ARTWORK
            Hero(
              tag: 'currentArtwork',
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: 300,
                  artworkWidth: 300,
                  artworkFit: BoxFit.cover,
                  keepOldArtwork: true, // Prevents white flash
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    size: 150,
                    color: AppPallete.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // TITLE
            Text(
              song.title,
              style: const TextStyle(
                color: AppPallete.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // ARTIST
            Text(
              song.artist,
              style: const TextStyle(color: AppPallete.grey, fontSize: 18),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET 2: Progress Bar
// Rebuilds constantly. Isolated to just this widget.
// -----------------------------------------------------------------------------
class _SmoothProgressBar extends StatelessWidget {
  const _SmoothProgressBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      // Only rebuild if position or duration changes
      buildWhen: (previous, current) =>
          previous.position != current.position ||
          previous.duration != current.duration,
      builder: (context, state) {
        final max = state.duration.inSeconds.toDouble();
        final value = state.position.inSeconds.toDouble().clamp(0.0, max);

        return Column(
          children: [
            Slider(
              min: 0,
              max: max,
              value: value,
              activeColor: AppPallete.primaryGreen,
              inactiveColor: AppPallete.grey,
              onChanged: (val) {
                // UI feedback only (optional)
              },
              onChangeEnd: (val) {
                context.read<MusicPlayerBloc>().add(
                  MusicPlayerEvent.seek(Duration(seconds: val.toInt())),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(state.position),
                    style: const TextStyle(color: AppPallete.grey),
                  ),
                  Text(
                    _formatDuration(state.duration),
                    style: const TextStyle(color: AppPallete.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

// -----------------------------------------------------------------------------
// WIDGET 3: Controls
// Rebuilds ONLY when Play/Pause state changes.
// -----------------------------------------------------------------------------
class _PlayerControls extends StatelessWidget {
  const _PlayerControls();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Transport
        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
            final isPlaying = state.isPlaying;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 36,
                    color: AppPallete.white,
                  ),
                  onPressed: () {
                    context.read<MusicPlayerBloc>().add(
                      const MusicPlayerEvent.playPreviousSong(),
                    );
                  },
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'playPauseBtn', // Unique tag to avoid conflicts
                  backgroundColor: AppPallete.primaryGreen,
                  onPressed: () {
                    final bloc = context.read<MusicPlayerBloc>();
                    if (isPlaying) {
                      bloc.add(const MusicPlayerEvent.pause());
                    } else {
                      bloc.add(const MusicPlayerEvent.resume());
                    }
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 36,
                    color: AppPallete.white,
                  ),
                  onPressed: () {
                    context.read<MusicPlayerBloc>().add(
                      const MusicPlayerEvent.playNextSong(),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        // Secondary Controls (Shuffle/Loop)
        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: state.isShuffling ? AppPallete.primaryGreen : AppPallete.grey,
                  ),
                  onPressed: () {
                     context.read<MusicPlayerBloc>().add(const MusicPlayerEvent.toggleShuffle());
                  },
                ),
                IconButton(
                  icon: Icon(
                    state.loopMode == 0 
                      ? Icons.repeat 
                      : (state.loopMode == 2 ? Icons.repeat_one : Icons.repeat),
                    color: state.loopMode > 0 ? AppPallete.primaryGreen : AppPallete.grey,
                  ),
                  onPressed: () {
                     context.read<MusicPlayerBloc>().add(const MusicPlayerEvent.cycleLoopMode());
                  },
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
