import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/onboarding/domain/repositories/onboarding_repository.dart';

class CacheFirstTimer implements UseCase<void, NoParams> {
  final OnboardingRepository onboardingRepository;

  CacheFirstTimer(this.onboardingRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await onboardingRepository.cacheFirstTimer();
  }
}
