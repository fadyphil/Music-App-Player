import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/features/analytics/domain/entities/play_log.dart';
import 'package:music_player/features/analytics/domain/services/music_analytics_service.dart';
import 'package:music_player/features/analytics/domain/usecases/log_playback.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';
import 'package:fpdart/fpdart.dart';

class MockAudioPlayerRepository extends Mock implements AudioPlayerRepository {}
class MockLogPlayback extends Mock implements LogPlayback {}

void main() {
  late MockAudioPlayerRepository mockAudioRepository;
  late MockLogPlayback mockLogPlayback;
  late MusicAnalyticsService service;

  late StreamController<bool> isPlayingController;
  late StreamController<SongEntity?> currentSongController;
  late StreamController<Duration> durationController;

  setUp(() {
    mockAudioRepository = MockAudioPlayerRepository();
    mockLogPlayback = MockLogPlayback();
    service = MusicAnalyticsService(mockAudioRepository, mockLogPlayback);

    isPlayingController = StreamController<bool>.broadcast();
    currentSongController = StreamController<SongEntity?>.broadcast();
    durationController = StreamController<Duration>.broadcast();

    when(() => mockAudioRepository.isPlayingStream).thenAnswer((_) => isPlayingController.stream);
    when(() => mockAudioRepository.currentSongStream).thenAnswer((_) => currentSongController.stream);
    when(() => mockAudioRepository.durationStream).thenAnswer((_) => durationController.stream);
    
    registerFallbackValue(PlayLog(
      songId: 0, 
      songTitle: '', 
      artist: '', 
      album: '', 
      genre: '', 
      timestamp: DateTime.now(), 
      durationListenedSeconds: 0, 
      isCompleted: false, 
      sessionTimeOfDay: ''
    ));
  });

  tearDown(() {
    isPlayingController.close();
    currentSongController.close();
    durationController.close();
    service.dispose();
  });

  final tSong = SongEntity(
    id: 1,
    title: 'Test Song',
    artist: 'Test Artist',
    album: 'Test Album',
    albumId: 1,
    path: 'path',
    duration: 60000, // 60 seconds (ms)
    size: 1000,
  );

  test('should accumulate duration when playing and log when song changes', () async {
    // Arrange
    when(() => mockLogPlayback(any())).thenAnswer((_) async => Right(null));
    service.init();
    
    // Act
    // 1. Start playing song
    currentSongController.add(tSong);
    isPlayingController.add(true);
    
    // 2. Wait 2 seconds (simulate listening)
    await Future.delayed(const Duration(seconds: 2));
    
    // 3. Pause
    isPlayingController.add(false);
    
    // 4. Wait 1 second (should not count)
    await Future.delayed(const Duration(seconds: 1));
    
    // 5. Resume
    isPlayingController.add(true);
    
    // 6. Wait 4 seconds (simulate listening) -> Total 6s
    await Future.delayed(const Duration(seconds: 4));
    
    // 7. Change song (triggers log for tSong)
    currentSongController.add(null);
    
    // Allow async processing
    await Future.delayed(const Duration(milliseconds: 100));

    // Assert
    // We expect log call with ~6 seconds
    verify(() => mockLogPlayback(any(that: isA<PlayLog>().having((log) => log.durationListenedSeconds, 'duration', greaterThanOrEqualTo(5))))).called(1);
  });

  test('should not log if song update is duplicate', () async {
    // Arrange
    when(() => mockLogPlayback(any())).thenAnswer((_) async => Right(null));
    service.init();
    
    // Act
    // 1. Start playing song
    currentSongController.add(tSong);
    isPlayingController.add(true);
    
    // 2. Wait 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // 3. Emit SAME song again (e.g. metadata update)
    currentSongController.add(tSong);
    
    // 4. Wait 4 seconds
    await Future.delayed(const Duration(seconds: 4));
    
    // 5. Change to new song
    currentSongController.add(null);
    await Future.delayed(const Duration(milliseconds: 100));

    // Assert
    // Should verify only ONE call (at the end), not an intermediate one.
    // The total duration should be around 6 seconds.
    verify(() => mockLogPlayback(any(that: isA<PlayLog>().having((log) => log.durationListenedSeconds, 'duration', greaterThanOrEqualTo(5))))).called(1);
  });
}