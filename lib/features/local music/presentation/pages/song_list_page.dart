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

// Add WidgetsBindingObserver to detect when user comes back from Settings
class _SongListPageState extends State<SongListPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen to App Lifecycle
    _initData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Detect when user returns to the app (e.g., from Settings)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Retry fetching when app resumes, in case user enabled permission
      _checkPermissionAndFetch();
    }
  }

  Future<void> _initData() async {
    // We wait for the frame to build so we can show Dialogs if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAndFetch();
    });
  }

  /// -----------------------------------------------------------------------
  /// PROFESSIONAL PERMISSION HANDLING LOGIC
  /// -----------------------------------------------------------------------
  Future<void> _checkPermissionAndFetch() async {
    // 1. Determine which permission to ask based on Android Version
    Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        permission = Permission.audio; // Android 13+
      } else {
        permission = Permission.storage; // Android 12-
      }
    } else {
      // iOS handling (if applicable later)
      permission = Permission.mediaLibrary;
    }

    // 2. Check current status
    final status = await permission.status;

    if (status.isGranted) {
      _fetchSongs();
    } else if (status.isDenied) {
      // First time asking, or denied previously but not permanently
      final result = await permission.request();
      if (result.isGranted) {
        _fetchSongs();
      } else if (result.isPermanentlyDenied) {
        _showGoToSettingsDialog();
      }
    } else if (status.isPermanentlyDenied) {
      // User previously checked "Don't ask again"
      _showGoToSettingsDialog();
    }
  }

  void _fetchSongs() {
    // Only add the event if the BLoC hasn't loaded data yet (optional optimization)
    // context.read<LocalMusicBloc>().add(const LocalMusicEvent.getLocalSongs());

    // For now, consistent with your logic:
    if (mounted) {
      // Ensure context is valid
      // Note: In your original code, you created the provider in build.
      // If you want to trigger this, the BlocProvider needs to be above this widget
      // OR you use a Builder/Consumer logic.
      // *Assuming BlocProvider is created in the build method below*:
      // We can't access it here easily unless we move Provider up or use a boolean flag
      // to start fetching in the BlocBuilder.

      // RECOMMENDATION: Logic keeps the state updated.
      // The UI simply reacts. If permission granted, we trigger the load inside the BlocProvider creation?
      // No, that's tricky with async permissions.

      // UPDATED STRATEGY:
      // We will pass a flag to the build method or let the Bloc handle the initial "Empty" state
      // and trigger the event here via a global key or changing state variable.
      // However, for this refactor, let's assume the build method handles the Provider.

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
              Navigator.pop(context); // Close dialog
              // Open App Settings
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

  /// -----------------------------------------------------------------------
  /// UI BUILD
  /// -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = serviceLocator<LocalMusicBloc>();
        // Only fetch if permission logic determined it's safe
        if (_hasPermission) {
          bloc.add(const LocalMusicEvent.getLocalSongs());
        }
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Logic to handle the "Not Granted" state UI
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
                    loaded: (songs) => _buildSliverLayout(songs),
                  );
                },
              ),

            Positioned(left: 0, right: 0, bottom: 0, child: const MiniPlayer()),
          ],
        ),
      ),
    );
  }

  // A nice UI to show when permission is missing (instead of a blank screen)
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

  // ... (Keep your existing _buildSliverLayout and sub-widgets exactly as they were)
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
