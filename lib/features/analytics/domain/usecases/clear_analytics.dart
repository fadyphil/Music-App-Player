import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

class ClearAnalytics implements UseCase<void, NoParams> {
  final AnalyticsRepository repository;

  ClearAnalytics(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearData();
  }
}
