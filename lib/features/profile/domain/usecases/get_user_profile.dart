import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile implements UseCase<UserEntity, NoParams> {
  final ProfileRepository _repository;

  GetUserProfile(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await _repository.getUserProfile();
  }
}
