import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_registration_state.freezed.dart';

@freezed
class UserRegistrationState with _$UserRegistrationState {
  const factory UserRegistrationState.initial() = _Initial;
  const factory UserRegistrationState.loading() = _Loading;
  const factory UserRegistrationState.success() = _Success;
  const factory UserRegistrationState.failure(String message) = _Failure;
}
