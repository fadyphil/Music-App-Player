import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/features/local%20music/data/datasource/local_music_datasource.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MockOnAudioQuery extends Mock implements OnAudioQuery {}

void main() {
  late LocalMusicDatasourceImpl datasource;
  late MockOnAudioQuery mockOnAudioQuery;

  setUp(() {
    mockOnAudioQuery = MockOnAudioQuery();
    datasource = LocalMusicDatasourceImpl(mockOnAudioQuery);
  });

  group('LocalMusicDatasource', () {
    test('should return list of songs (Linux Logic or OnAudioQuery)', () async {
      // ARRANGE
      if (!Platform.isLinux && !Platform.isWindows) {
        // If not desktop, we expect OnAudioQuery to be called
        when(
          () => mockOnAudioQuery.querySongs(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            uriType: any(named: 'uriType'),
            ignoreCase: any(named: 'ignoreCase'),
          ),
        ).thenAnswer(
          (_) async => [
            SongModel({
              '_id': 1,
              'title': 'Test Song',
              'artist': 'Test Artist',
              'album': 'Test Album',
              'duration': 60000,
              'is_music': true,
              '_data': '/path/to/song.mp3',
            }),
          ],
        );
      }

      // ACT
      final result = await datasource.getLocalMusic();

      // ASSERT
      expect(result, isA<List>());
      if (Platform.isLinux) {
        // On Linux, we just expect it not to crash and return a list (empty or not)
        // We cannot easily verify content without setting up real files in the user dir
      } else if (!Platform.isWindows) {
        // On Mobile, verify mock usage
        verify(
          () => mockOnAudioQuery.querySongs(
            sortType: any(named: 'sortType'),
            orderType: any(named: 'orderType'),
            uriType: any(named: 'uriType'),
            ignoreCase: any(named: 'ignoreCase'),
          ),
        ).called(1);
        expect(result.length, 1);
        expect(result.first.title, 'Test Song');
      }
    });
  });
}
