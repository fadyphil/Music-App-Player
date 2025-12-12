import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../profile/domain/usecases/update_user_profile.dart';
import '../../../profile/domain/entities/user_entity.dart';
import '../../domain/usecases/log_onboarding_complete.dart';
import '../../domain/usecases/cache_first_timer.dart';
import 'user_registration_state.dart';

class UserRegistrationCubit extends Cubit<UserRegistrationState> {
  final UpdateUserProfile _updateUserProfile;
  final LogOnboardingComplete _logOnboardingComplete;
  final CacheFirstTimer _cacheFirstTimer;

  UserRegistrationCubit({
    required UpdateUserProfile updateUserProfile,
    required LogOnboardingComplete logOnboardingComplete,
    required CacheFirstTimer cacheFirstTimer,
  })  : _updateUserProfile = updateUserProfile,
        _logOnboardingComplete = logOnboardingComplete,
        _cacheFirstTimer = cacheFirstTimer,
        super(const UserRegistrationState.initial());

  Future<void> submitForm({
    required String name,
    required String email,
    String? avatarPath,
  }) async {
    emit(const UserRegistrationState.loading());

    // 1. Create User Entity
    // Note: We are creating a new user or updating the default one. 
    // Since we don't have authentication, we stick to ID 'user_1' or generate a new one.
    // We'll stick to 'user_1' to match the default in ProfileLocalDataSource.
    final user = UserEntity(
      id: 'user_1', 
      username: name,
      email: email,
      avatarUrl: avatarPath ?? '',
      preferredNavBar: NavBarStyle.simple, // Default
    );

    // 2. Save User
    final result = await _updateUserProfile(user);

    result.fold(
      (failure) => emit(UserRegistrationState.failure(failure.message)),
      (_) async {
        // 3. Log Analytics & Cache First Timer
        await _logOnboardingComplete(NoParams());
        await _cacheFirstTimer(NoParams());
        
        emit(const UserRegistrationState.success());
      },
    );
  }
}
