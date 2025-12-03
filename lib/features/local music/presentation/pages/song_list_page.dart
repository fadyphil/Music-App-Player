import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_bloc.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_event.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_state.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_event.dart';
import 'package:music_player/features/music_player/presentation/widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// Imports from your architecture
import '../../../../core/di/init_dependencies.dart';
import '../../../../core/theme/app_pallete.dart'; // <--- Using the Design System
import '../../domain/entities/song_entity.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetch();
  }

  Future<void> _checkPermissionAndFetch() async {
    // Basic permission check
    if (await Permission.audio.status.isDenied) {
      await [Permission.audio, Permission.storage].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LocalMusicBloc>()
        ..add(
          const LocalMusicEvent.getLocalSongs(),
        ), // Verify event name matches your file
      child: Scaffold(
        // Use the theme background (AppPallete.backgroundColor)
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            BlocBuilder<LocalMusicBloc, LocalMusicState>(
              builder: (context, state) {
                return state.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.gradientTop,
                    ),
                  ),
                  failure: (failure) => Center(
                    child: Text(
                      "Error: ${failure.message}",
                      style: const TextStyle(color: AppPallete.white),
                    ),
                  ),
                  loaded: (songs) => _buildSliverLayout(songs),
                );
              },
            ),

            // Mini Player stays on top
            Positioned(left: 0, right: 0, bottom: 0, child: const MiniPlayer()),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverLayout(List<SongEntity> songs) {
    return CustomScrollView(
      slivers: [
        // 1. The Dynamic App Bar (Handles Gradient & Collapsing Title)
        SliverAppBar(
          expandedHeight: 280.0,
          floating: false,
          pinned: true, // This makes it stick to the top
          backgroundColor: AppPallete.backgroundColor, // Black when collapsed
          elevation: 0,

          // The Title that appears when collapsed
          title: const Text(
            "Local Songs",
            style: TextStyle(
              color: AppPallete.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          // The Background Gradient (FlexibleSpace)
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppPallete.gradientTop, // Blue
                    AppPallete.gradientBottom, // Black
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Push content down
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar inside the gradient
                    SongsSearchBar(),
                    const SizedBox(height: 20),

                    // Big Title (Disappears as you scroll up due to FlexibleSpace logic)
                    const Text(
                      "Local Songs",
                      style: TextStyle(
                        color: AppPallete.white,
                        fontSize: 32, // Bigger font for expanded state
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${songs.length} songs",
                      style: const TextStyle(
                        color: AppPallete.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Controls Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.download_for_offline_outlined,
                              color: AppPallete.grey,
                              size: 30,
                            ),
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.shuffle,
                              color: AppPallete.grey,
                              size: 30,
                            ),
                          ],
                        ),
                        // Play Button
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: AppPallete.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 2. The List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final song = songs[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppPallete.cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    color: AppPallete.grey,
                  ),
                ),
              ),
              title: Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppPallete.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                song.artist,
                maxLines: 1,
                style: const TextStyle(color: AppPallete.grey, fontSize: 13),
              ),
              trailing: Text(
                _formatDuration(
                  song.duration.toInt(),
                ), // Ensure duration is int
                style: const TextStyle(color: AppPallete.grey, fontSize: 12),
              ),
              onTap: () {
                context.read<MusicPlayerBloc>().add(
                  MusicPlayerEvent.initMusicQueue(
                    songs: songs,
                    currentIndex: index,
                  ),
                );
              },
            );
          }, childCount: songs.length),
        ),

        // Bottom Padding
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class SongsSearchBar extends StatelessWidget {
  const SongsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppPallete.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, color: AppPallete.white),
          const SizedBox(width: 10),
          const Text(
            "Find in local songs",
            style: TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppPallete.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Sort",
              style: TextStyle(color: AppPallete.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
