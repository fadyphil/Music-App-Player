// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:music_player/features/analytics/domain/services/music_analytics_service.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:music_player/main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

// Mocks
class MockMusicPlayerBloc extends Mock implements MusicPlayerBloc {}
class MockMusicAnalyticsService extends Mock implements MusicAnalyticsService {}
class MockOnboardingCubit extends MockCubit<int> implements OnboardingCubit {}

void main() {
  setUpAll(() {
    // Register generic fallbacks if needed
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Setup GetIt
    final getIt = GetIt.instance;
    getIt.registerLazySingleton<MusicPlayerBloc>(() => MockMusicPlayerBloc());
    getIt.registerLazySingleton<MusicAnalyticsService>(() => MockMusicAnalyticsService());
    
    final mockOnboardingCubit = MockOnboardingCubit();
    when(() => mockOnboardingCubit.state).thenReturn(0);
    getIt.registerFactory<OnboardingCubit>(() => mockOnboardingCubit);

    // Build our app and trigger a frame.
    // Pass isFirstRun: true or false depending on what we want to smoke test
    await tester.pumpWidget(const MyApp(isFirstRun: true));

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
