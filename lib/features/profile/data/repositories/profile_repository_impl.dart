import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../failures/profile_failure.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await _dataSource.getUserProfile();
      return right(user);
    } catch (e) {
      return left(ProfileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user) async {
    try {
      await _dataSource.saveUserProfile(user);
      return right(user);
    } catch (e) {
      return left(ProfileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _dataSource.clearCache();
      return right(null);
    } catch (e) {
      return left(ProfileFailure(e.toString()));
    }
  }
}
