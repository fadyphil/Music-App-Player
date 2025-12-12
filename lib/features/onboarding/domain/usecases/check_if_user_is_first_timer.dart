import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckIfUserIsFirstTimer implements UseCase<bool, NoParams> {
  final OnboardingRepository onboardingRepository;

  CheckIfUserIsFirstTimer(this.onboardingRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await onboardingRepository.checkIfUserIsFirstTimer();
  }
}
