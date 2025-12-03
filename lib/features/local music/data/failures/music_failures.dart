import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/core/error/failure.dart';

part 'music_failures.freezed.dart';

@freezed
abstract class MusicFailures with _$MusicFailures implements Failure {
  const MusicFailures._();

  const factory MusicFailures.permissionDenied({
    @Default('Storage permission denied') String message,
  }) = _PermissionDenied;

  const factory MusicFailures.storageError({
    @Default('failed to read storage') String message,
  }) = _StorageError;

  const factory MusicFailures.unexpected({required String message}) =
      _Unexpected;
}
