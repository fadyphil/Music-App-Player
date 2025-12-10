import 'package:flutter/material.dart';
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
    // 1. Desktop / Custom Byte Artwork
    // if (song.artworkBytes != null) {
    //   return ClipRRect(
    //     borderRadius: borderRadius ?? BorderRadius.circular(4),
    //     child: Image.memory(
    //       song.artworkBytes!,
    //       width: size,
    //       height: size,
    //       fit: BoxFit.cover,
    //       errorBuilder: (_, __, ___) => _buildPlaceholder(),
    //     ),
    //   );
    // }

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
