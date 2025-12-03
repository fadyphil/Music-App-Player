import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/local%20music/domain/repositories/music_repository.dart';

class GetLocalSongsUseCase implements UseCase<List<SongEntity>, NoParams> {
  final MusicRepository musicRepository;
  GetLocalSongsUseCase(this.musicRepository);

  @override
  Future<Either<Failure, List<SongEntity>>> call(NoParams params) async {
    return await musicRepository.getLocalSongs();
  }
}
