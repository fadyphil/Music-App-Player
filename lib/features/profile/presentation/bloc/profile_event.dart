part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile() = _LoadProfile;
  const factory ProfileEvent.updateProfile(UserEntity user) = _UpdateProfile;
  const factory ProfileEvent.clearCache() = _ClearCache;
  const factory ProfileEvent.changeNavBarStyle(NavBarStyle style) = _ChangeNavBarStyle;
}
