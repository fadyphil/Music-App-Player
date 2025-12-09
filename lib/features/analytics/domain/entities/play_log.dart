import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_log.freezed.dart';
part 'play_log.g.dart';

DateTime _fromMillis(int date) => DateTime.fromMillisecondsSinceEpoch(date);
int _toMillis(DateTime date) => date.millisecondsSinceEpoch;

@freezed
abstract class PlayLog with _$PlayLog { // Make PlayLog abstract
  const factory PlayLog({
    int? id,
    @JsonKey(name: 'song_id') required int songId,
    @JsonKey(name: 'title') required String songTitle,
    @JsonKey(name: 'artist') required String artist,
    @JsonKey(name: 'album') required String album,
    @JsonKey(name: 'genre') required String genre,
    @JsonKey(name: 'timestamp', fromJson: _fromMillis, toJson: _toMillis) required DateTime timestamp,
    @JsonKey(name: 'duration_listened') required int durationListenedSeconds,
    @JsonKey(name: 'is_completed') required bool isCompleted,
    required String sessionTimeOfDay,
  }) = _PlayLog;

  factory PlayLog.fromJson(Map<String, dynamic> json) => _$PlayLogFromJson(json);
}