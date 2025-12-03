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
      List<SongModel> rawsongs = await _onAudioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      final validSongs = rawsongs
          .where(
            (s) =>
                (s.isMusic == true || s.isPodcast == true) &&
                (s.duration ?? 0) > 5000,
          )
          .toList();
      return validSongs.map((song) => SongMapper.toEntity(song)).toList();
    } catch (e) {
      throw Exception('Error getting local music: $e');
    }
  }
}
