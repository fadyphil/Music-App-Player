part of 'analytics_bloc.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.logPlayback(PlayLog log) = _LogPlaybackEvent;
  const factory AnalyticsEvent.loadAnalyticsData({
    @Default(TimeFrame.week) TimeFrame timeFrame,
  }) = _LoadAnalyticsData;
}
