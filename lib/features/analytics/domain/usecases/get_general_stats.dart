import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_enums.dart';
import '../entities/analytics_stats.dart';
import '../repositories/analytics_repository.dart';

class GetGeneralStats implements UseCase<ListeningStats, TimeFrame> {
  final AnalyticsRepository repository;

  GetGeneralStats(this.repository);

  @override
  Future<Either<Failure, ListeningStats>> call(TimeFrame params) async {
    return await repository.getGeneralStats(params);
  }
}
