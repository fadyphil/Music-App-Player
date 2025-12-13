import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class ClearCache implements UseCase<void, NoParams> {
  final ProfileRepository _repository;

  ClearCache(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.clearCache();
  }
}
