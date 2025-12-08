import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/presentation/pages/music_player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/music_player_bloc.dart';
import '../bloc/music_player_event.dart';
import '../bloc/music_player_state.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Top Level Selector: ONLY rebuilds if the current song changes.
    // This stops the Container from repainting constantly.
    return BlocSelector<MusicPlayerBloc, MusicPlayerState, SongEntity?>(
      selector: (state) => state.currentSong,
      builder: (context, song) {
        if (song == null) return const SizedBox.shrink();

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
                      // Since 'song' is passed down and doesn't change every millisecond,
                      // this widget will NOT rebuild during playback.
                      Hero(
                        tag:
                            'currentArtwork', // Must match the tag in MusicPlayerPage
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
                            keepOldArtwork:
                                true, // Prevents white flash when switching songs
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
                      const SizedBox(width: 10),

                      // TEXT (Stable)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppPallete.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              song.artist,
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

                      // PLAY BUTTON (Reactive to isPlaying only)
                      const _PlayPauseButton(),
                    ],
                  ),
                ),

                // PROGRESS BAR (Reactive to position only)
                const _MiniPlayerProgressBar(),
              ],
            ),
          ),
        );
      },
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
