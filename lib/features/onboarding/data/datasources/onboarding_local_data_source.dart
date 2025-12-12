import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_player/features/onboarding/domain/failure/onboarding_failure.dart';

abstract interface class OnboardingLocalDataSource {
  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await sharedPreferences.setBool('is_first_timer', false);
    } catch (e) {
      throw OnboardingFailure(e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      return sharedPreferences.getBool('is_first_timer') ?? true;
    } catch (e) {
      throw OnboardingFailure(e.toString());
    }
  }
}