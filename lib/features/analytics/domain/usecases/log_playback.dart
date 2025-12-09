import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/play_log.dart';
import '../repositories/analytics_repository.dart';

class LogPlayback implements UseCase<void, PlayLog> {
  final AnalyticsRepository repository;

  LogPlayback(this.repository);

  @override
  Future<Either<Failure, void>> call(PlayLog params) async {
    return await repository.logEvent(params);
  }
}
