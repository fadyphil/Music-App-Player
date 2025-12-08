import 'package:freezed_annotation/freezed_annotation.dart';
part 'song_entity.freezed.dart';

@freezed
abstract class SongEntity with _$SongEntity {
  const factory SongEntity({
    required int id,
    required String title,
    required String artist,
    required String album,
    required int? albumId,
    required String path,
    required double duration,
    required int size,
  }) = _SongEntity;
}
