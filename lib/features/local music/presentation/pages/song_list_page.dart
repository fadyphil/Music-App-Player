import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_event.dart';
import 'package:music_player/features/music_player/presentation/widgets/mini_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Architecture Imports
import '../../../../core/di/init_dependencies.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/song_entity.dart';
import '../managers/local_music_bloc.dart';
import '../managers/local_music_event.dart';
import '../managers/local_music_state.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndFetch();
    }
  }

  Future<void> _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAndFetch();
    });
  }

  Future<void> _checkPermissionAndFetch() async {
    Permission permission;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        permission = Permission.audio;
      } else {
        permission = Permission.storage;
      }
    } else {
      permission = Permission.mediaLibrary;
    }

    final status = await permission.status;

    if (status.isGranted) {
      _fetchSongs();
    } else if (status.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        _fetchSongs();
      } else if (result.isPermanentlyDenied) {
        _showGoToSettingsDialog();
      }
    } else if (status.isPermanentlyDenied) {
      _showGoToSettingsDialog();
    }
  }

  void _fetchSongs() {
    if (mounted) {
      setState(() {
        _hasPermission = true;
      });
    }
  }

  bool _hasPermission = false;

  void _showGoToSettingsDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppPallete.cardColor,
        title: const Text(
          "Permission Required",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This app needs access to your audio files to play music. \n\nPlease go to settings and enable 'Music and Audio' access.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text(
              "Open Settings",
              style: TextStyle(color: AppPallete.primaryGreen),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppPallete.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = serviceLocator<LocalMusicBloc>();
        if (_hasPermission) {
          bloc.add(const LocalMusicEvent.getLocalSongs());
        }
        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        body: Stack(
          children: [
            if (!_hasPermission) _buildPermissionRequestUI(),
            if (_hasPermission)
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    loaded: (songs) => SliverLayout(songs: songs),
                  );
                },
              ),
            Positioned(left: 0, right: 0, bottom: 0, child: const MiniPlayer()),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRequestUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_off, size: 80, color: AppPallete.grey),
          const SizedBox(height: 20),
          const Text(
            "Storage Access Needed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _checkPermissionAndFetch,
            style: TextButton.styleFrom(
              backgroundColor: AppPallete.primaryGreen,
            ),
            child: const Text(
              "Grant Permission",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEW SLIVER LAYOUT IMPLEMENTATION
  // ---------------------------------------------------------------------------

  // String _formatDuration(int milliseconds) {
  //   final duration = Duration(milliseconds: milliseconds);
  //   final minutes = duration.inMinutes;
  //   final seconds = duration.inSeconds.remainder(60);
  //   return '$minutes:${seconds.toString().padLeft(2, '0')}';
  // }
}

class SliverLayout extends StatelessWidget {
  const SliverLayout({super.key, required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1. The Complex Header (Search + Title + Controls)
        SongListPageSliverAppBar(songs: songs),

        // 2. The "Add to Playlist" Button (Part of the scrollable list)
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        //     child: Row(
        //       children: [
        //         Container(
        //           height: 48,
        //           width: 48,
        //           decoration: BoxDecoration(
        //             color: Colors.grey[900],
        //             borderRadius: BorderRadius.circular(4),
        //           ),
        //           child: const Icon(Icons.add, color: Colors.white70, size: 28),
        //         ),
        //         const SizedBox(width: 16),
        //         const Text(
        //           "Add to this playlist",
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // 3. The Song List
        SongListPageSliverTile(songs: songs),

        // Bottom Padding for MiniPlayer
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class SongListPageSliverTile extends StatelessWidget {
  const SongListPageSliverTile({super.key, required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final song = songs[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          leading: Container(
            width: 48,
            height: 48,
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
              artworkFit: BoxFit.cover,
              artworkBorder: BorderRadius.circular(4),
              artworkWidth: 48,
              artworkHeight: 48,
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
          subtitle: Row(
            children: [
              // Explicit Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  "E",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppPallete.grey, fontSize: 13),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.more_vert, color: AppPallete.grey),
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
    );
  }
}

class SongListPageSliverAppBar extends StatelessWidget {
  const SongListPageSliverAppBar({super.key, required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 290.0,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor:
          AppPallete.gradientTop, // Visible only when 100% collapsed
      // 1. Back Button
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),

      // 2. Flexible Space with LayoutBuilder for Scroll Animations
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // --- MATH SECTION ---
          var top = constraints.biggest.height;
          var expandedHeight = 300.0;
          var safePadding = MediaQuery.of(context).padding.top;
          var toolbarHeight = kToolbarHeight + safePadding;

          // t ranges from 1.0 (Fully Expanded) to 0.0 (Fully Collapsed)
          var t = ((top - toolbarHeight) / (expandedHeight - toolbarHeight))
              .clamp(0.0, 1.0);

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 48, 56, 204), // Top Blue
                  Color.fromARGB(255, 41, 48, 146), // Mid
                  AppPallete.backgroundColor, // Bottom Black
                ],
                stops: [0.3, 0.6, 0.8],
              ),
            ),
            child: Stack(
              children: [
                // -----------------------------------------------------------
                // LAYER A: The "Expanded" Content (Fades OUT as we scroll up)
                // -----------------------------------------------------------
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: expandedHeight,
                  child: Opacity(
                    // Fades out faster than it collapses (looks cleaner)
                    opacity: t < 0.2 ? 0.0 : t,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(flex: 4),
                            // 1. Search Bar
                            const SongsSearchBar(),

                            const Spacer(flex: 3),

                            // 2. Big Title
                            const Text(
                              "Local Songs",
                              style: TextStyle(
                                color: AppPallete.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32, // Big Size
                              ),
                            ),
                            const SizedBox(height: 8),

                            // 3. Song Count
                            Text(
                              "${songs.length} songs",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 4. Icons Row (Download, Shuffle) - Note: Play button is separate
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white30,
                                      width: 1.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.shuffle,
                                  color: AppPallete.primaryGreen,
                                  size: 28,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // -----------------------------------------------------------
                // LAYER B: The "Collapsed" Title (Fades IN as we scroll up)
                // -----------------------------------------------------------
                Positioned(
                  top: safePadding, // Align with the AppBar/Leading icon
                  left: 0,
                  right: 0,
                  height: kToolbarHeight,
                  child: Opacity(
                    // Starts appearing when t < 0.4 (nearly collapsed)
                    opacity: (1 - t) > 0.6 ? 1.0 : 0.0,
                    child: const Center(
                      child: Text(
                        "Local Songs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // -----------------------------------------------------------
                // LAYER C: The Floating Play Button (Sticks to Edge)
                // -----------------------------------------------------------
                Positioned(
                  right: 16,
                  bottom: 18, // Always 16px from bottom, regardless of height
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: const BoxDecoration(
                      color: AppPallete.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (songs.isNotEmpty) {
                          context.read<MusicPlayerBloc>().add(
                            MusicPlayerEvent.initMusicQueue(
                              songs: songs,
                              currentIndex: 0,
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SongsSearchBar extends StatelessWidget {
  const SongsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.search, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Find in Local Songs",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Sort Button
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: const Text(
            "Sort",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
