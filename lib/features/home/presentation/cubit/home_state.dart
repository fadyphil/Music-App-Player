import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeTab { songs, analytics, profile }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({@Default(HomeTab.songs) HomeTab selectedTab}) =
      _HomeState;
}
