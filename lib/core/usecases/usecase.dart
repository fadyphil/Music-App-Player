import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';

abstract class UseCase<type, Params> {
  Future<Either<Failure, type>> call(Params params);
}

class NoParams<type> {}
