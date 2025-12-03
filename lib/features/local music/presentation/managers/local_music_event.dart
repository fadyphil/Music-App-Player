import 'package:freezed_annotation/freezed_annotation.dart';
part 'local_music_event.freezed.dart';

@freezed
class LocalMusicEvent with _$LocalMusicEvent {
  const factory LocalMusicEvent.getLocalSongs() = _GetLocalSongs;
}
