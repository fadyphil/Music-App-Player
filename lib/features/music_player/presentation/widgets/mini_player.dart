import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_player/presentation/pages/music_player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/music_player_bloc.dart';
import '../bloc/music_player_event.dart';
import '../bloc/music_player_state.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late PageController _pageController;
  int _lastKnownIndex = 0;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicPlayerBloc, MusicPlayerState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (context, state) {
        if (_pageController.hasClients && !_isUserScrolling) {
          final currentPage = _pageController.page?.round() ?? 0;
          if (currentPage != state.currentIndex) {
             _lastKnownIndex = state.currentIndex;
             _pageController.jumpToPage(state.currentIndex);
          }
        }
      },
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) =>
            previous.currentSong != current.currentSong ||
            previous.queue != current.queue,
        builder: (context, state) {
          final song = state.currentSong;
          if (song == null) return const SizedBox.shrink();

          // Sync controller if it's the first load or desynced
          if (_pageController.hasClients && !_isUserScrolling &&
              (_pageController.page?.round() ?? 0) != state.currentIndex) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
               if (_pageController.hasClients && !_isUserScrolling) {
                 _pageController.jumpToPage(state.currentIndex);
               }
             });
          }

          // Safe Queue Access
          final queue = state.queue.isEmpty ? [song] : state.queue;
          final itemCount = queue.length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MusicPlayerPage();
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 66,
              decoration: BoxDecoration(
                color: AppPallete.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // ARTWORK (Stable)
                        Hero(
                          tag: 'currentArtwork',
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppPallete.grey,
                            ),
                            child: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: AppPallete.white,
                              ),
                              artworkHeight: 50,
                              artworkWidth: 50,
                              artworkBorder: BorderRadius.circular(4),
                              artworkFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // TEXT (PageView for Swiping)
                        Expanded(
                          child: NotificationListener<UserScrollNotification>(
                            onNotification: (notification) {
                              if (notification.direction == ScrollDirection.idle) {
                                _isUserScrolling = false;
                              } else {
                                _isUserScrolling = true;
                              }
                              return false;
                            },
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: itemCount,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                  // Only trigger if meaningful change
                                  if (index != _lastKnownIndex) {
                                    _lastKnownIndex = index;
                                    context.read<MusicPlayerBloc>().add(
                                      MusicPlayerEvent.initMusicQueue(
                                        songs: queue,
                                        currentIndex: index,
                                      ),
                                    );
                                  }
                              },
                              itemBuilder: (context, index) {
                                final itemSong = queue[index];
                                return RepaintBoundary(
                                  child: AnimatedBuilder(
                                    animation: _pageController,
                                    builder: (context, child) {
                                      double opacity = 1.0;
                                      if (_pageController.position.haveDimensions) {
                                         double page = _pageController.page ?? 0;
                                         double dist = (page - index).abs();
                                         // Smoother cubic fade
                                         opacity = (1 - (dist * dist * dist)).clamp(0.0, 1.0);
                                      }
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemSong.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppPallete.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            itemSong.artist,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppPallete.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // PLAY BUTTON
                        const _PlayPauseButton(),
                      ],
                    ),
                  ),

                  // PROGRESS BAR
                  const _MiniPlayerProgressBar(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Sub-widget 1: Only rebuilds when Play/Pause state changes
class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MusicPlayerBloc, MusicPlayerState, bool>(
      selector: (state) => state.isPlaying,
      builder: (context, isPlaying) {
        return IconButton(
          onPressed: () {
            final bloc = context.read<MusicPlayerBloc>();
            if (isPlaying) {
              bloc.add(const MusicPlayerEvent.pause());
            } else {
              bloc.add(const MusicPlayerEvent.resume());
            }
          },
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppPallete.white,
          ),
        );
      },
    );
  }
}

// Sub-widget 2: Rebuilds constantly (Isolation)
// This isolates the heavy repainting to just this tiny line, not the whole image.
class _MiniPlayerProgressBar extends StatelessWidget {
  const _MiniPlayerProgressBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      buildWhen: (previous, current) =>
          previous.position != current.position ||
          previous.duration != current.duration,
      builder: (context, state) {
        if (state.duration.inSeconds <= 0) return const SizedBox.shrink();

        final value = state.position.inSeconds / state.duration.inSeconds;
        // Clamp value to prevent crash if position > duration temporarily
        final clampedValue = value.clamp(0.0, 1.0);

        return LinearProgressIndicator(
          value: clampedValue,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppPallete.primaryGreen,
          ),
          minHeight: 2,
        );
      },
    );
  }
}
