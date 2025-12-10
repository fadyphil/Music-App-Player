import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:music_player/features/background-notification-feature/data/datasources/audio_handler.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeAudioSource extends Fake implements AudioSource {}

void main() {
  late MusicPlayerHandler handler;
  late MockAudioPlayer mockPlayer;

  setUpAll(() {
    registerFallbackValue(FakeAudioSource());
    registerFallbackValue(LoopMode.off);
  });

  setUp(() {
    mockPlayer = MockAudioPlayer();
    // Helper to allow void callbacks
    when(
      () => mockPlayer.playbackEventStream,
    ).thenAnswer((_) => Stream.empty());
    when(
      () => mockPlayer.sequenceStateStream,
    ).thenAnswer((_) => Stream.empty());
    when(() => mockPlayer.position).thenReturn(Duration.zero);
    when(() => mockPlayer.bufferedPosition).thenReturn(Duration.zero);
    when(() => mockPlayer.speed).thenReturn(1.0);
    when(() => mockPlayer.playing).thenReturn(false);
    when(() => mockPlayer.processingState).thenReturn(ProcessingState.idle);
    when(
      () => mockPlayer.setAudioSources(
        any(),
        initialIndex: any(named: 'initialIndex'),
      ),
    ).thenAnswer((_) async => null);

    handler = MusicPlayerHandler(player: mockPlayer);
  });

  group('MusicPlayerHandler', () {
    test('play calls _player.play', () async {
      when(() => mockPlayer.play()).thenAnswer((_) async {});
      await handler.play();
      verify(() => mockPlayer.play()).called(1);
    });

    test('pause calls _player.pause', () async {
      when(() => mockPlayer.pause()).thenAnswer((_) async {});
      await handler.pause();
      verify(() => mockPlayer.pause()).called(1);
    });

    test('skipToNext calls _player.seekToNext', () async {
      when(() => mockPlayer.seekToNext()).thenAnswer((_) async {});
      await handler.skipToNext();
      verify(() => mockPlayer.seekToNext()).called(1);
    });

    test('skipToPrevious calls _player.seekToPrevious', () async {
      when(() => mockPlayer.seekToPrevious()).thenAnswer((_) async {});
      await handler.skipToPrevious();
      verify(() => mockPlayer.seekToPrevious()).called(1);
    });

    test('setShuffleMode enables shuffle on player', () async {
      when(
        () => mockPlayer.setShuffleModeEnabled(any()),
      ).thenAnswer((_) async {});
      when(() => mockPlayer.shuffle()).thenAnswer((_) async {});

      await handler.setShuffleMode(AudioServiceShuffleMode.all);

      verify(() => mockPlayer.shuffle()).called(1);
      verify(() => mockPlayer.setShuffleModeEnabled(true)).called(1);
    });

    test('setRepeatMode sets loop mode on player', () async {
      when(() => mockPlayer.setLoopMode(any())).thenAnswer((_) async {});

      await handler.setRepeatMode(AudioServiceRepeatMode.one);
      verify(() => mockPlayer.setLoopMode(LoopMode.one)).called(1);

      await handler.setRepeatMode(AudioServiceRepeatMode.all);
      verify(() => mockPlayer.setLoopMode(LoopMode.all)).called(1);
    });
  });
}
