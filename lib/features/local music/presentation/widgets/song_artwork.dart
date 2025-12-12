import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongArtwork extends StatelessWidget {
  final SongEntity song;
  final double size;
  final BorderRadius? borderRadius;

  const SongArtwork({
    super.key,
    required this.song,
    this.size = 52,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      // 2. Android/iOS QueryArtworkWidget
      return QueryArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: _buildPlaceholder(),
        artworkFit: BoxFit.cover,
        artworkHeight: size,
        artworkWidth: size,
        artworkBorder: borderRadius ?? BorderRadius.circular(4),
      );
    }

    // 2. Desktop (Linux/Windows): Extract Image from File ID3 Tags
    return FutureBuilder<Metadata?>(
      // We read the metadata from the specific file path (song.data)
      future: MetadataRetriever.fromFile(File(song.path)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.albumArt != null) {
          return ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            child: Image.memory(
              snapshot.data!.albumArt!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              // gaplessPlayback prevents white flickering when scrolling
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _buildPlaceholder(),
            ),
          );
        }
        // While loading or if no art exists, show placeholder
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: Colors.white30,
        size: size * 0.5,
      ),
    );
  }
}
