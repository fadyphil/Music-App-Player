import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../analytics/domain/repositories/analytics_repository.dart';

class LogOnboardingComplete implements UseCase<void, NoParams> {
  final AnalyticsRepository repository;

  LogOnboardingComplete(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logOnboardingComplete();
  }
}
