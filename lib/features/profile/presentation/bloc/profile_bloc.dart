import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/clear_cache.dart';
import '../../../../core/usecases/usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final ClearCache _clearCache;

  ProfileBloc({
    required GetUserProfile getUserProfile,
    required UpdateUserProfile updateUserProfile,
    required ClearCache clearCache,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        _clearCache = clearCache,
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
    final result = await _clearCache(NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) {
        emit(const ProfileState.cacheCleared());
      },
    );
  }

  Future<void> _onChangeNavBarStyle(_ChangeNavBarStyle event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedUser = currentState.user.copyWith(preferredNavBar: event.style);
      add(ProfileEvent.updateProfile(updatedUser));
    }
  }
}
