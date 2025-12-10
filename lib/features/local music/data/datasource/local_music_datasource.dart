import 'dart:io';

import 'package:music_player/features/local%20music/data/models/song_model.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class LocalMusicDatasource {
  Future<List<SongEntity>> getLocalMusic();
}

class LocalMusicDatasourceImpl implements LocalMusicDatasource {
  final OnAudioQuery _onAudioQuery;
  LocalMusicDatasourceImpl(this._onAudioQuery);

  @override
  Future<List<SongEntity>> getLocalMusic() async {
    try {
      // Linux Native Implementation: Manually scan directories
      // This bypasses on_audio_query which may lack native implementations on some distros.
      if (Platform.isLinux) {
        return _getLinuxSongs();
      }

      List<SongModel> rawsongs;

      if (Platform.isMacOS || Platform.isWindows) {
        rawsongs = await _onAudioQuery.querySongs();
      } else {
        rawsongs = await _onAudioQuery.querySongs(
          sortType: SongSortType.DATE_ADDED,
          orderType: OrderType.DESC_OR_GREATER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        );
      }
      // 2. Platform-Specific Filtering
      final validSongs = rawsongs.where((s) {
        // Common Check: Duration must be > 5 seconds (filters blips/notifications)
        final bool hasDuration = (s.duration ?? 0) > 5000;

        if (!hasDuration) return false;

        // Desktop Check:
        // On Linux, 'isMusic' relies on file metadata which might be missing.
        // Since the library scans the Music folder, we assume files found are valid audio.
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          return true;
        }

        // Mobile Check:
        // On Android, we must strictly filter out Ringtones/Notifications/Alarms
        return (s.isMusic == true || s.isPodcast == true);
      }).toList();

      return validSongs.map((song) => SongMapper.toEntity(song)).toList();
    } catch (e) {
      throw Exception('Error getting local music: $e');
    }
  }

  Future<List<SongEntity>> _getLinuxSongs() async {
    final List<SongEntity> songs = [];
    final home = Platform.environment['HOME'];
    if (home == null) return [];

    final dirsToScan = [
      Directory('$home/Music'),
      Directory('$home/Downloads'),
    ];

    for (final dir in dirsToScan) {
      if (!await dir.exists()) continue;
      try {
        await for (final file
            in dir.list(recursive: true, followLinks: false)) {
          if (file is File) {
            final path = file.path.toLowerCase();
            if (path.endsWith('.mp3') ||
                path.endsWith('.m4a') ||
                path.endsWith('.wav') ||
                path.endsWith('.ogg') ||
                path.endsWith('.flac')) {
              
              final filename = file.path.split(Platform.pathSeparator).last;
              
              // Heuristic: "Artist - Title.mp3"
              String title = filename;
              String artist = 'Unknown Artist';
              final nameWithoutExt = filename.contains('.') 
                  ? filename.substring(0, filename.lastIndexOf('.'))
                  : filename;
                  
              if (nameWithoutExt.contains(' - ')) {
                final parts = nameWithoutExt.split(' - ');
                artist = parts[0].trim();
                title = parts.sublist(1).join(' - ').trim();
              } else {
                title = nameWithoutExt;
              }

              songs.add(SongEntity(
                id: file.path.hashCode,
                title: title,
                artist: artist,
                album: 'Unknown Album',
                albumId: 0,
                path: file.path,
                duration: 0, // Duration unknown without metadata parser
                size: await file.length(),
              ));
            }
          }
        }
      } catch (e) {
        // Ignore permission errors or specific dir errors
        continue;
      }
    }
    return songs;
  }
}
