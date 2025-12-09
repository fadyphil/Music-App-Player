import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_stats.freezed.dart';
part 'analytics_stats.g.dart';

@freezed
abstract class TopItem with _$TopItem {
  const TopItem._(); // Private constructor to allow custom methods/getters

  const factory TopItem({
    required String id,
    @JsonKey(name: 'label') required String title,
    @JsonKey(name: 'sub_label') String? subtitle,
    @JsonKey(name: 'value') required int count,
    @Default('unknown') String type,
  }) = _TopItem;

  factory TopItem.fromJson(Map<String, dynamic> json) =>
      _$TopItemFromJson(json);
}

@freezed
abstract class ListeningStats with _$ListeningStats {
  const ListeningStats._(); // Private constructor

  const factory ListeningStats({
    @JsonKey(name: 'total_duration') required int totalMinutes,
    @JsonKey(name: 'total_count') required int totalSongsPlayed,
    @Default({}) Map<String, int> timeOfDayDistribution,
  }) = _ListeningStats;

  factory ListeningStats.fromJson(Map<String, dynamic> json) =>
      _$ListeningStatsFromJson(json);
}
