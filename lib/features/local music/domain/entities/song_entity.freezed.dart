// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SongEntity {

 int get id; String get title; String get artist; String get album; String get path; double get duration; int get size;
/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongEntityCopyWith<SongEntity> get copyWith => _$SongEntityCopyWithImpl<SongEntity>(this as SongEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SongEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.path, path) || other.path == path)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,artist,album,path,duration,size);

@override
String toString() {
  return 'SongEntity(id: $id, title: $title, artist: $artist, album: $album, path: $path, duration: $duration, size: $size)';
}


}

/// @nodoc
abstract mixin class $SongEntityCopyWith<$Res>  {
  factory $SongEntityCopyWith(SongEntity value, $Res Function(SongEntity) _then) = _$SongEntityCopyWithImpl;
@useResult
$Res call({
 int id, String title, String artist, String album, String path, double duration, int size
});




}
/// @nodoc
class _$SongEntityCopyWithImpl<$Res>
    implements $SongEntityCopyWith<$Res> {
  _$SongEntityCopyWithImpl(this._self, this._then);

  final SongEntity _self;
  final $Res Function(SongEntity) _then;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? path = null,Object? duration = null,Object? size = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SongEntity].
extension SongEntityPatterns on SongEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SongEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SongEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SongEntity value)  $default,){
final _that = this;
switch (_that) {
case _SongEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SongEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SongEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String artist,  String album,  String path,  double duration,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SongEntity() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.path,_that.duration,_that.size);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String artist,  String album,  String path,  double duration,  int size)  $default,) {final _that = this;
switch (_that) {
case _SongEntity():
return $default(_that.id,_that.title,_that.artist,_that.album,_that.path,_that.duration,_that.size);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String artist,  String album,  String path,  double duration,  int size)?  $default,) {final _that = this;
switch (_that) {
case _SongEntity() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.path,_that.duration,_that.size);case _:
  return null;

}
}

}

/// @nodoc


class _SongEntity implements SongEntity {
  const _SongEntity({required this.id, required this.title, required this.artist, required this.album, required this.path, required this.duration, required this.size});
  

@override final  int id;
@override final  String title;
@override final  String artist;
@override final  String album;
@override final  String path;
@override final  double duration;
@override final  int size;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongEntityCopyWith<_SongEntity> get copyWith => __$SongEntityCopyWithImpl<_SongEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.path, path) || other.path == path)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,artist,album,path,duration,size);

@override
String toString() {
  return 'SongEntity(id: $id, title: $title, artist: $artist, album: $album, path: $path, duration: $duration, size: $size)';
}


}

/// @nodoc
abstract mixin class _$SongEntityCopyWith<$Res> implements $SongEntityCopyWith<$Res> {
  factory _$SongEntityCopyWith(_SongEntity value, $Res Function(_SongEntity) _then) = __$SongEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String artist, String album, String path, double duration, int size
});




}
/// @nodoc
class __$SongEntityCopyWithImpl<$Res>
    implements _$SongEntityCopyWith<$Res> {
  __$SongEntityCopyWithImpl(this._self, this._then);

  final _SongEntity _self;
  final $Res Function(_SongEntity) _then;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? path = null,Object? duration = null,Object? size = null,}) {
  return _then(_SongEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
