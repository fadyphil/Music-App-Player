import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/onboarding/domain/usecases/cache_first_timer.dart';

class OnboardingCubit extends Cubit<int> {
  final CacheFirstTimer _cacheFirstTimer;

  OnboardingCubit({
    required CacheFirstTimer cacheFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        super(0);

  void pageChanged(int index) {
    emit(index);
  }

  Future<void> cacheFirstRun() async {
    await _cacheFirstTimer(NoParams());
  }
}
