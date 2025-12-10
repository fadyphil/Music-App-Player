import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/features/background-notification-feature/data/datasources/audio_handler.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/data/repos/audio_player_repository_impl.dart';

class MockAudioHandler extends Mock implements MusicPlayerHandler {}

void main() {
  late AudioPlayerRepositoryImpl repository;
  late MockAudioHandler mockAudioHandler;

  setUp(() {
    mockAudioHandler = MockAudioHandler();
    repository = AudioPlayerRepositoryImpl(mockAudioHandler);
  });

  group('AudioPlayerRepository', () {
    const tSong = SongEntity(
      id: 1,
      title: 'Title',
      artist: 'Artist',
      album: 'Album',
      path: 'path',
      duration: 1000,
      size: 1000,
      albumId: 123,
    );

    test('setQueue delegates to AudioHandler.setQueueItems', () async {
      // ARRANGE
      when(
        () => mockAudioHandler.setQueueItems(
          items: any(named: 'items'),
          initialIndex: any(named: 'initialIndex'),
        ),
      ).thenAnswer((_) async {});

      // ACT
      await repository.setQueue([tSong], 0);

      // ASSERT
      verify(
        () => mockAudioHandler.setQueueItems(
          items: any(named: 'items'),
          initialIndex: 0,
        ),
      ).called(1);
    });

    test('playSong delegates to AudioHandler.playSong', () async {
      // ARRANGE
      when(
        () => mockAudioHandler.playSong(
          uri: any(named: 'uri'),
          title: any(named: 'title'),
          artist: any(named: 'artist'),
          id: any(named: 'id'),
          artUri: any(named: 'artUri'),
        ),
      ).thenAnswer((_) async {});

      // ACT
      await repository.playSong('path', 'Title', 'Artist', '1', '123');

      // ASSERT
      verify(
        () => mockAudioHandler.playSong(
          uri: 'path',
          title: 'Title',
          artist: 'Artist',
          id: '1',
          artUri: any(named: 'artUri'),
        ),
      ).called(1);
    });
  });
}
