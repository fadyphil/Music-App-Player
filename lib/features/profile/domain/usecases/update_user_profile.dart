import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile implements UseCase<UserEntity, UserEntity> {
  final ProfileRepository _repository;

  UpdateUserProfile(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await _repository.updateUserProfile(user);
  }
}
