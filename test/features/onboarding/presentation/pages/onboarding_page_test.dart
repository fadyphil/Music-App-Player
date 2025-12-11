import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:music_player/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:music_player/features/onboarding/presentation/pages/onboarding_page.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

void main() {
  late MockCacheFirstTimer mockCacheFirstTimer;
  late OnboardingCubit onboardingCubit;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockCacheFirstTimer = MockCacheFirstTimer();
    // Stub the call
    when(() => mockCacheFirstTimer(any())).thenAnswer((_) async => const Right(null));
    
    onboardingCubit = OnboardingCubit(cacheFirstTimer: mockCacheFirstTimer);

    // Register in GetIt
    final getIt = GetIt.instance;
    // Ensure clean slate is handled by tearDown, but safety check here
    if (getIt.isRegistered<OnboardingCubit>()) {
      getIt.unregister<OnboardingCubit>();
    }
    getIt.registerSingleton<OnboardingCubit>(onboardingCubit);
  });
  
  tearDown(() {
    GetIt.instance.reset();
    onboardingCubit.close();
  });

  group('OnboardingPage Widget Tests', () {
    testWidgets('renders first page content initially', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));

      expect(find.text('Welcome to Music Player'), findsOneWidget);
      expect(find.text('Smart Analytics'), findsNothing); // Should be off-screen
    });

    testWidgets('taping Next moves to second page', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));

      // Tap Next
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text('Smart Analytics'), findsOneWidget);
    });

    testWidgets('taping Skip triggers completion and caching', (tester) async {
      bool onDoneCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingPage(
            onDone: () {
              onDoneCalled = true;
            },
          ),
        ),
      );

      // Tap Skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      verify(() => mockCacheFirstTimer(any())).called(1);
      expect(onDoneCalled, true);
    });
    
    testWidgets('completing flow triggers completion and caching', (tester) async {
      bool onDoneCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingPage(
            onDone: () {
              onDoneCalled = true;
            },
          ),
        ),
      );

      // Page 1 -> 2
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Page 2 -> 3
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify we are on last page (Done button appears as check icon)
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap Done
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      
      verify(() => mockCacheFirstTimer(any())).called(1);
      expect(onDoneCalled, true);
    });
  });
}