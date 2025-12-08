// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MusicPlayerState {

 bool get isPlaying; Duration get position; Duration get duration;// We keep track of the current song path to highlight it in the list
 SongEntity? get currentSong; List<SongEntity> get queue; int get currentIndex; bool get isShuffling; int get loopMode;// 0: Off, 1: All, 2: One
 bool get isPlaylistEnd; bool get isLoading; bool get isPlayerReady; bool get isSeeking; bool get isPlayingFromQueue; bool get isPlayingFromPlaylist;
/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MusicPlayerStateCopyWith<MusicPlayerState> get copyWith => _$MusicPlayerStateCopyWithImpl<MusicPlayerState>(this as MusicPlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MusicPlayerState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.currentSong, currentSong) || other.currentSong == currentSong)&&const DeepCollectionEquality().equals(other.queue, queue)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.isShuffling, isShuffling) || other.isShuffling == isShuffling)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode)&&(identical(other.isPlaylistEnd, isPlaylistEnd) || other.isPlaylistEnd == isPlaylistEnd)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPlayerReady, isPlayerReady) || other.isPlayerReady == isPlayerReady)&&(identical(other.isSeeking, isSeeking) || other.isSeeking == isSeeking)&&(identical(other.isPlayingFromQueue, isPlayingFromQueue) || other.isPlayingFromQueue == isPlayingFromQueue)&&(identical(other.isPlayingFromPlaylist, isPlayingFromPlaylist) || other.isPlayingFromPlaylist == isPlayingFromPlaylist));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,position,duration,currentSong,const DeepCollectionEquality().hash(queue),currentIndex,isShuffling,loopMode,isPlaylistEnd,isLoading,isPlayerReady,isSeeking,isPlayingFromQueue,isPlayingFromPlaylist);

@override
String toString() {
  return 'MusicPlayerState(isPlaying: $isPlaying, position: $position, duration: $duration, currentSong: $currentSong, queue: $queue, currentIndex: $currentIndex, isShuffling: $isShuffling, loopMode: $loopMode, isPlaylistEnd: $isPlaylistEnd, isLoading: $isLoading, isPlayerReady: $isPlayerReady, isSeeking: $isSeeking, isPlayingFromQueue: $isPlayingFromQueue, isPlayingFromPlaylist: $isPlayingFromPlaylist)';
}


}

/// @nodoc
abstract mixin class $MusicPlayerStateCopyWith<$Res>  {
  factory $MusicPlayerStateCopyWith(MusicPlayerState value, $Res Function(MusicPlayerState) _then) = _$MusicPlayerStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, Duration position, Duration duration, SongEntity? currentSong, List<SongEntity> queue, int currentIndex, bool isShuffling, int loopMode, bool isPlaylistEnd, bool isLoading, bool isPlayerReady, bool isSeeking, bool isPlayingFromQueue, bool isPlayingFromPlaylist
});


$SongEntityCopyWith<$Res>? get currentSong;

}
/// @nodoc
class _$MusicPlayerStateCopyWithImpl<$Res>
    implements $MusicPlayerStateCopyWith<$Res> {
  _$MusicPlayerStateCopyWithImpl(this._self, this._then);

  final MusicPlayerState _self;
  final $Res Function(MusicPlayerState) _then;

/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPlaying = null,Object? position = null,Object? duration = null,Object? currentSong = freezed,Object? queue = null,Object? currentIndex = null,Object? isShuffling = null,Object? loopMode = null,Object? isPlaylistEnd = null,Object? isLoading = null,Object? isPlayerReady = null,Object? isSeeking = null,Object? isPlayingFromQueue = null,Object? isPlayingFromPlaylist = null,}) {
  return _then(_self.copyWith(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,currentSong: freezed == currentSong ? _self.currentSong : currentSong // ignore: cast_nullable_to_non_nullable
as SongEntity?,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<SongEntity>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,isShuffling: null == isShuffling ? _self.isShuffling : isShuffling // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as int,isPlaylistEnd: null == isPlaylistEnd ? _self.isPlaylistEnd : isPlaylistEnd // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlayerReady: null == isPlayerReady ? _self.isPlayerReady : isPlayerReady // ignore: cast_nullable_to_non_nullable
as bool,isSeeking: null == isSeeking ? _self.isSeeking : isSeeking // ignore: cast_nullable_to_non_nullable
as bool,isPlayingFromQueue: null == isPlayingFromQueue ? _self.isPlayingFromQueue : isPlayingFromQueue // ignore: cast_nullable_to_non_nullable
as bool,isPlayingFromPlaylist: null == isPlayingFromPlaylist ? _self.isPlayingFromPlaylist : isPlayingFromPlaylist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get currentSong {
    if (_self.currentSong == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.currentSong!, (value) {
    return _then(_self.copyWith(currentSong: value));
  });
}
}


/// Adds pattern-matching-related methods to [MusicPlayerState].
extension MusicPlayerStatePatterns on MusicPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MusicPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MusicPlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MusicPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _MusicPlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MusicPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _MusicPlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPlaying,  Duration position,  Duration duration,  SongEntity? currentSong,  List<SongEntity> queue,  int currentIndex,  bool isShuffling,  int loopMode,  bool isPlaylistEnd,  bool isLoading,  bool isPlayerReady,  bool isSeeking,  bool isPlayingFromQueue,  bool isPlayingFromPlaylist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MusicPlayerState() when $default != null:
return $default(_that.isPlaying,_that.position,_that.duration,_that.currentSong,_that.queue,_that.currentIndex,_that.isShuffling,_that.loopMode,_that.isPlaylistEnd,_that.isLoading,_that.isPlayerReady,_that.isSeeking,_that.isPlayingFromQueue,_that.isPlayingFromPlaylist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPlaying,  Duration position,  Duration duration,  SongEntity? currentSong,  List<SongEntity> queue,  int currentIndex,  bool isShuffling,  int loopMode,  bool isPlaylistEnd,  bool isLoading,  bool isPlayerReady,  bool isSeeking,  bool isPlayingFromQueue,  bool isPlayingFromPlaylist)  $default,) {final _that = this;
switch (_that) {
case _MusicPlayerState():
return $default(_that.isPlaying,_that.position,_that.duration,_that.currentSong,_that.queue,_that.currentIndex,_that.isShuffling,_that.loopMode,_that.isPlaylistEnd,_that.isLoading,_that.isPlayerReady,_that.isSeeking,_that.isPlayingFromQueue,_that.isPlayingFromPlaylist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPlaying,  Duration position,  Duration duration,  SongEntity? currentSong,  List<SongEntity> queue,  int currentIndex,  bool isShuffling,  int loopMode,  bool isPlaylistEnd,  bool isLoading,  bool isPlayerReady,  bool isSeeking,  bool isPlayingFromQueue,  bool isPlayingFromPlaylist)?  $default,) {final _that = this;
switch (_that) {
case _MusicPlayerState() when $default != null:
return $default(_that.isPlaying,_that.position,_that.duration,_that.currentSong,_that.queue,_that.currentIndex,_that.isShuffling,_that.loopMode,_that.isPlaylistEnd,_that.isLoading,_that.isPlayerReady,_that.isSeeking,_that.isPlayingFromQueue,_that.isPlayingFromPlaylist);case _:
  return null;

}
}

}

/// @nodoc


class _MusicPlayerState implements MusicPlayerState {
  const _MusicPlayerState({this.isPlaying = false, this.position = Duration.zero, this.duration = Duration.zero, this.currentSong, final  List<SongEntity> queue = const [], this.currentIndex = 0, this.isShuffling = false, this.loopMode = 0, this.isPlaylistEnd = false, this.isLoading = false, this.isPlayerReady = false, this.isSeeking = false, this.isPlayingFromQueue = false, this.isPlayingFromPlaylist = false}): _queue = queue;
  

@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration duration;
// We keep track of the current song path to highlight it in the list
@override final  SongEntity? currentSong;
 final  List<SongEntity> _queue;
@override@JsonKey() List<SongEntity> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

@override@JsonKey() final  int currentIndex;
@override@JsonKey() final  bool isShuffling;
@override@JsonKey() final  int loopMode;
// 0: Off, 1: All, 2: One
@override@JsonKey() final  bool isPlaylistEnd;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isPlayerReady;
@override@JsonKey() final  bool isSeeking;
@override@JsonKey() final  bool isPlayingFromQueue;
@override@JsonKey() final  bool isPlayingFromPlaylist;

/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MusicPlayerStateCopyWith<_MusicPlayerState> get copyWith => __$MusicPlayerStateCopyWithImpl<_MusicPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MusicPlayerState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.currentSong, currentSong) || other.currentSong == currentSong)&&const DeepCollectionEquality().equals(other._queue, _queue)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.isShuffling, isShuffling) || other.isShuffling == isShuffling)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode)&&(identical(other.isPlaylistEnd, isPlaylistEnd) || other.isPlaylistEnd == isPlaylistEnd)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPlayerReady, isPlayerReady) || other.isPlayerReady == isPlayerReady)&&(identical(other.isSeeking, isSeeking) || other.isSeeking == isSeeking)&&(identical(other.isPlayingFromQueue, isPlayingFromQueue) || other.isPlayingFromQueue == isPlayingFromQueue)&&(identical(other.isPlayingFromPlaylist, isPlayingFromPlaylist) || other.isPlayingFromPlaylist == isPlayingFromPlaylist));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,position,duration,currentSong,const DeepCollectionEquality().hash(_queue),currentIndex,isShuffling,loopMode,isPlaylistEnd,isLoading,isPlayerReady,isSeeking,isPlayingFromQueue,isPlayingFromPlaylist);

@override
String toString() {
  return 'MusicPlayerState(isPlaying: $isPlaying, position: $position, duration: $duration, currentSong: $currentSong, queue: $queue, currentIndex: $currentIndex, isShuffling: $isShuffling, loopMode: $loopMode, isPlaylistEnd: $isPlaylistEnd, isLoading: $isLoading, isPlayerReady: $isPlayerReady, isSeeking: $isSeeking, isPlayingFromQueue: $isPlayingFromQueue, isPlayingFromPlaylist: $isPlayingFromPlaylist)';
}


}

/// @nodoc
abstract mixin class _$MusicPlayerStateCopyWith<$Res> implements $MusicPlayerStateCopyWith<$Res> {
  factory _$MusicPlayerStateCopyWith(_MusicPlayerState value, $Res Function(_MusicPlayerState) _then) = __$MusicPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPlaying, Duration position, Duration duration, SongEntity? currentSong, List<SongEntity> queue, int currentIndex, bool isShuffling, int loopMode, bool isPlaylistEnd, bool isLoading, bool isPlayerReady, bool isSeeking, bool isPlayingFromQueue, bool isPlayingFromPlaylist
});


@override $SongEntityCopyWith<$Res>? get currentSong;

}
/// @nodoc
class __$MusicPlayerStateCopyWithImpl<$Res>
    implements _$MusicPlayerStateCopyWith<$Res> {
  __$MusicPlayerStateCopyWithImpl(this._self, this._then);

  final _MusicPlayerState _self;
  final $Res Function(_MusicPlayerState) _then;

/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? position = null,Object? duration = null,Object? currentSong = freezed,Object? queue = null,Object? currentIndex = null,Object? isShuffling = null,Object? loopMode = null,Object? isPlaylistEnd = null,Object? isLoading = null,Object? isPlayerReady = null,Object? isSeeking = null,Object? isPlayingFromQueue = null,Object? isPlayingFromPlaylist = null,}) {
  return _then(_MusicPlayerState(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,currentSong: freezed == currentSong ? _self.currentSong : currentSong // ignore: cast_nullable_to_non_nullable
as SongEntity?,queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<SongEntity>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,isShuffling: null == isShuffling ? _self.isShuffling : isShuffling // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as int,isPlaylistEnd: null == isPlaylistEnd ? _self.isPlaylistEnd : isPlaylistEnd // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlayerReady: null == isPlayerReady ? _self.isPlayerReady : isPlayerReady // ignore: cast_nullable_to_non_nullable
as bool,isSeeking: null == isSeeking ? _self.isSeeking : isSeeking // ignore: cast_nullable_to_non_nullable
as bool,isPlayingFromQueue: null == isPlayingFromQueue ? _self.isPlayingFromQueue : isPlayingFromQueue // ignore: cast_nullable_to_non_nullable
as bool,isPlayingFromPlaylist: null == isPlayingFromPlaylist ? _self.isPlayingFromPlaylist : isPlayingFromPlaylist // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MusicPlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get currentSong {
    if (_self.currentSong == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.currentSong!, (value) {
    return _then(_self.copyWith(currentSong: value));
  });
}
}

// dart format on
