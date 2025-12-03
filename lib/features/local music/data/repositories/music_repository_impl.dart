import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/local%20music/data/datasource/local_music_datasource.dart';
import 'package:music_player/features/local%20music/data/failures/music_failures.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/local%20music/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final LocalMusicDatasource _localMusicDatasource;

  MusicRepositoryImpl(this._localMusicDatasource);

  @override
  Future<Either<Failure, List<SongEntity>>> getLocalSongs() async {
    try {
      final songs = await _localMusicDatasource.getLocalMusic();
      return Right(songs);
    } catch (e) {
      return Left(MusicFailures.storageError(message: e.toString()));
    }
  }
}
