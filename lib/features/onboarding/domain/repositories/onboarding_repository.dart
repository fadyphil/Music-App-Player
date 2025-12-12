import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, void>> cacheFirstTimer();
  Future<Either<Failure, bool>> checkIfUserIsFirstTimer();
}
