import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/clear_cache.dart';
import '../../../analytics/domain/usecases/clear_analytics.dart';
import '../../../../core/usecases/usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final ClearCache _clearCache;
  final ClearAnalytics _clearAnalytics;

  ProfileBloc({
    required GetUserProfile getUserProfile,
    required UpdateUserProfile updateUserProfile,
    required ClearCache clearCache,
    required ClearAnalytics clearAnalytics,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        _clearCache = clearCache,
        _clearAnalytics = clearAnalytics,
        super(const ProfileState.initial()) {
    on<_LoadProfile>(_onLoadProfile);
    on<_UpdateProfile>(_onUpdateProfile);
    on<_ClearCache>(_onClearCache);
    on<_ChangeNavBarStyle>(_onChangeNavBarStyle);
  }

  Future<void> _onLoadProfile(_LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _getUserProfile(NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<void> _onUpdateProfile(_UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _updateUserProfile(event.user);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<void> _onClearCache(_ClearCache event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    
    // 1. Clear Profile Cache
    final cacheResult = await _clearCache(NoParams());
    
    // 2. Clear Analytics (Run in parallel or sequence? Sequence to ensure safety)
    final analyticsResult = await _clearAnalytics(NoParams());

    // Check if either failed. 
    // If profile clear fails, we have an issue. If analytics fails, it's less critical but still an error.
    if (cacheResult.isLeft()) {
      cacheResult.fold((l) => emit(ProfileState.error(l.message)), (_) {});
      return;
    }

    // We assume analytics clear usually works. Even if it fails, the user is effectively reset.
    // But let's be strict.
    if (analyticsResult.isLeft()) {
       analyticsResult.fold((l) => emit(ProfileState.error(l.message)), (_) {});
       return;
    }

    emit(const ProfileState.cacheCleared());
  }

  Future<void> _onChangeNavBarStyle(_ChangeNavBarStyle event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedUser = currentState.user.copyWith(preferredNavBar: event.style);
      add(ProfileEvent.updateProfile(updatedUser));
    }
  }
}
