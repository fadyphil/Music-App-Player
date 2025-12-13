import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

class GetAllSongPlayCounts implements UseCase<Map<int, int>, NoParams> {
  final AnalyticsRepository repository;

  GetAllSongPlayCounts(this.repository);

  @override
  Future<Either<Failure, Map<int, int>>> call(NoParams params) async {
    return await repository.getAllSongPlayCounts();
  }
}
