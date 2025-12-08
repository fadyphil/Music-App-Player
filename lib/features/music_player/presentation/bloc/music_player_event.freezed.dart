// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music_player_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MusicPlayerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MusicPlayerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent()';
}


}

/// @nodoc
class $MusicPlayerEventCopyWith<$Res>  {
$MusicPlayerEventCopyWith(MusicPlayerEvent _, $Res Function(MusicPlayerEvent) __);
}


/// Adds pattern-matching-related methods to [MusicPlayerEvent].
extension MusicPlayerEventPatterns on MusicPlayerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InitMusicQueue value)?  initMusicQueue,TResult Function( _PlaySong value)?  playSong,TResult Function( _Pause value)?  pause,TResult Function( _Resume value)?  resume,TResult Function( _Seek value)?  seek,TResult Function( _PreviousSong value)?  playPreviousSong,TResult Function( _NextSong value)?  playNextSong,TResult Function( _ToggleShuffle value)?  toggleShuffle,TResult Function( _CycleLoopMode value)?  cycleLoopMode,TResult Function( _UpdatePosition value)?  updatePosition,TResult Function( _UpdateDuration value)?  updateDuration,TResult Function( _UpdatePlayerState value)?  updatePlayerState,TResult Function( _UpdateShuffleState value)?  updateShuffleState,TResult Function( _UpdateLoopState value)?  updateLoopState,TResult Function( _UpdateCurrentSong value)?  updateCurrentSong,TResult Function( _SongFinished value)?  songFinished,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitMusicQueue() when initMusicQueue != null:
return initMusicQueue(_that);case _PlaySong() when playSong != null:
return playSong(_that);case _Pause() when pause != null:
return pause(_that);case _Resume() when resume != null:
return resume(_that);case _Seek() when seek != null:
return seek(_that);case _PreviousSong() when playPreviousSong != null:
return playPreviousSong(_that);case _NextSong() when playNextSong != null:
return playNextSong(_that);case _ToggleShuffle() when toggleShuffle != null:
return toggleShuffle(_that);case _CycleLoopMode() when cycleLoopMode != null:
return cycleLoopMode(_that);case _UpdatePosition() when updatePosition != null:
return updatePosition(_that);case _UpdateDuration() when updateDuration != null:
return updateDuration(_that);case _UpdatePlayerState() when updatePlayerState != null:
return updatePlayerState(_that);case _UpdateShuffleState() when updateShuffleState != null:
return updateShuffleState(_that);case _UpdateLoopState() when updateLoopState != null:
return updateLoopState(_that);case _UpdateCurrentSong() when updateCurrentSong != null:
return updateCurrentSong(_that);case _SongFinished() when songFinished != null:
return songFinished(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InitMusicQueue value)  initMusicQueue,required TResult Function( _PlaySong value)  playSong,required TResult Function( _Pause value)  pause,required TResult Function( _Resume value)  resume,required TResult Function( _Seek value)  seek,required TResult Function( _PreviousSong value)  playPreviousSong,required TResult Function( _NextSong value)  playNextSong,required TResult Function( _ToggleShuffle value)  toggleShuffle,required TResult Function( _CycleLoopMode value)  cycleLoopMode,required TResult Function( _UpdatePosition value)  updatePosition,required TResult Function( _UpdateDuration value)  updateDuration,required TResult Function( _UpdatePlayerState value)  updatePlayerState,required TResult Function( _UpdateShuffleState value)  updateShuffleState,required TResult Function( _UpdateLoopState value)  updateLoopState,required TResult Function( _UpdateCurrentSong value)  updateCurrentSong,required TResult Function( _SongFinished value)  songFinished,}){
final _that = this;
switch (_that) {
case _InitMusicQueue():
return initMusicQueue(_that);case _PlaySong():
return playSong(_that);case _Pause():
return pause(_that);case _Resume():
return resume(_that);case _Seek():
return seek(_that);case _PreviousSong():
return playPreviousSong(_that);case _NextSong():
return playNextSong(_that);case _ToggleShuffle():
return toggleShuffle(_that);case _CycleLoopMode():
return cycleLoopMode(_that);case _UpdatePosition():
return updatePosition(_that);case _UpdateDuration():
return updateDuration(_that);case _UpdatePlayerState():
return updatePlayerState(_that);case _UpdateShuffleState():
return updateShuffleState(_that);case _UpdateLoopState():
return updateLoopState(_that);case _UpdateCurrentSong():
return updateCurrentSong(_that);case _SongFinished():
return songFinished(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InitMusicQueue value)?  initMusicQueue,TResult? Function( _PlaySong value)?  playSong,TResult? Function( _Pause value)?  pause,TResult? Function( _Resume value)?  resume,TResult? Function( _Seek value)?  seek,TResult? Function( _PreviousSong value)?  playPreviousSong,TResult? Function( _NextSong value)?  playNextSong,TResult? Function( _ToggleShuffle value)?  toggleShuffle,TResult? Function( _CycleLoopMode value)?  cycleLoopMode,TResult? Function( _UpdatePosition value)?  updatePosition,TResult? Function( _UpdateDuration value)?  updateDuration,TResult? Function( _UpdatePlayerState value)?  updatePlayerState,TResult? Function( _UpdateShuffleState value)?  updateShuffleState,TResult? Function( _UpdateLoopState value)?  updateLoopState,TResult? Function( _UpdateCurrentSong value)?  updateCurrentSong,TResult? Function( _SongFinished value)?  songFinished,}){
final _that = this;
switch (_that) {
case _InitMusicQueue() when initMusicQueue != null:
return initMusicQueue(_that);case _PlaySong() when playSong != null:
return playSong(_that);case _Pause() when pause != null:
return pause(_that);case _Resume() when resume != null:
return resume(_that);case _Seek() when seek != null:
return seek(_that);case _PreviousSong() when playPreviousSong != null:
return playPreviousSong(_that);case _NextSong() when playNextSong != null:
return playNextSong(_that);case _ToggleShuffle() when toggleShuffle != null:
return toggleShuffle(_that);case _CycleLoopMode() when cycleLoopMode != null:
return cycleLoopMode(_that);case _UpdatePosition() when updatePosition != null:
return updatePosition(_that);case _UpdateDuration() when updateDuration != null:
return updateDuration(_that);case _UpdatePlayerState() when updatePlayerState != null:
return updatePlayerState(_that);case _UpdateShuffleState() when updateShuffleState != null:
return updateShuffleState(_that);case _UpdateLoopState() when updateLoopState != null:
return updateLoopState(_that);case _UpdateCurrentSong() when updateCurrentSong != null:
return updateCurrentSong(_that);case _SongFinished() when songFinished != null:
return songFinished(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<SongEntity> songs,  int currentIndex)?  initMusicQueue,TResult Function( SongEntity song)?  playSong,TResult Function()?  pause,TResult Function()?  resume,TResult Function( Duration position)?  seek,TResult Function()?  playPreviousSong,TResult Function()?  playNextSong,TResult Function()?  toggleShuffle,TResult Function()?  cycleLoopMode,TResult Function( Duration position)?  updatePosition,TResult Function( Duration duration)?  updateDuration,TResult Function( bool isPlaying)?  updatePlayerState,TResult Function( bool isShuffleModeEnabled)?  updateShuffleState,TResult Function( int loopMode)?  updateLoopState,TResult Function( SongEntity song)?  updateCurrentSong,TResult Function()?  songFinished,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitMusicQueue() when initMusicQueue != null:
return initMusicQueue(_that.songs,_that.currentIndex);case _PlaySong() when playSong != null:
return playSong(_that.song);case _Pause() when pause != null:
return pause();case _Resume() when resume != null:
return resume();case _Seek() when seek != null:
return seek(_that.position);case _PreviousSong() when playPreviousSong != null:
return playPreviousSong();case _NextSong() when playNextSong != null:
return playNextSong();case _ToggleShuffle() when toggleShuffle != null:
return toggleShuffle();case _CycleLoopMode() when cycleLoopMode != null:
return cycleLoopMode();case _UpdatePosition() when updatePosition != null:
return updatePosition(_that.position);case _UpdateDuration() when updateDuration != null:
return updateDuration(_that.duration);case _UpdatePlayerState() when updatePlayerState != null:
return updatePlayerState(_that.isPlaying);case _UpdateShuffleState() when updateShuffleState != null:
return updateShuffleState(_that.isShuffleModeEnabled);case _UpdateLoopState() when updateLoopState != null:
return updateLoopState(_that.loopMode);case _UpdateCurrentSong() when updateCurrentSong != null:
return updateCurrentSong(_that.song);case _SongFinished() when songFinished != null:
return songFinished();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<SongEntity> songs,  int currentIndex)  initMusicQueue,required TResult Function( SongEntity song)  playSong,required TResult Function()  pause,required TResult Function()  resume,required TResult Function( Duration position)  seek,required TResult Function()  playPreviousSong,required TResult Function()  playNextSong,required TResult Function()  toggleShuffle,required TResult Function()  cycleLoopMode,required TResult Function( Duration position)  updatePosition,required TResult Function( Duration duration)  updateDuration,required TResult Function( bool isPlaying)  updatePlayerState,required TResult Function( bool isShuffleModeEnabled)  updateShuffleState,required TResult Function( int loopMode)  updateLoopState,required TResult Function( SongEntity song)  updateCurrentSong,required TResult Function()  songFinished,}) {final _that = this;
switch (_that) {
case _InitMusicQueue():
return initMusicQueue(_that.songs,_that.currentIndex);case _PlaySong():
return playSong(_that.song);case _Pause():
return pause();case _Resume():
return resume();case _Seek():
return seek(_that.position);case _PreviousSong():
return playPreviousSong();case _NextSong():
return playNextSong();case _ToggleShuffle():
return toggleShuffle();case _CycleLoopMode():
return cycleLoopMode();case _UpdatePosition():
return updatePosition(_that.position);case _UpdateDuration():
return updateDuration(_that.duration);case _UpdatePlayerState():
return updatePlayerState(_that.isPlaying);case _UpdateShuffleState():
return updateShuffleState(_that.isShuffleModeEnabled);case _UpdateLoopState():
return updateLoopState(_that.loopMode);case _UpdateCurrentSong():
return updateCurrentSong(_that.song);case _SongFinished():
return songFinished();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<SongEntity> songs,  int currentIndex)?  initMusicQueue,TResult? Function( SongEntity song)?  playSong,TResult? Function()?  pause,TResult? Function()?  resume,TResult? Function( Duration position)?  seek,TResult? Function()?  playPreviousSong,TResult? Function()?  playNextSong,TResult? Function()?  toggleShuffle,TResult? Function()?  cycleLoopMode,TResult? Function( Duration position)?  updatePosition,TResult? Function( Duration duration)?  updateDuration,TResult? Function( bool isPlaying)?  updatePlayerState,TResult? Function( bool isShuffleModeEnabled)?  updateShuffleState,TResult? Function( int loopMode)?  updateLoopState,TResult? Function( SongEntity song)?  updateCurrentSong,TResult? Function()?  songFinished,}) {final _that = this;
switch (_that) {
case _InitMusicQueue() when initMusicQueue != null:
return initMusicQueue(_that.songs,_that.currentIndex);case _PlaySong() when playSong != null:
return playSong(_that.song);case _Pause() when pause != null:
return pause();case _Resume() when resume != null:
return resume();case _Seek() when seek != null:
return seek(_that.position);case _PreviousSong() when playPreviousSong != null:
return playPreviousSong();case _NextSong() when playNextSong != null:
return playNextSong();case _ToggleShuffle() when toggleShuffle != null:
return toggleShuffle();case _CycleLoopMode() when cycleLoopMode != null:
return cycleLoopMode();case _UpdatePosition() when updatePosition != null:
return updatePosition(_that.position);case _UpdateDuration() when updateDuration != null:
return updateDuration(_that.duration);case _UpdatePlayerState() when updatePlayerState != null:
return updatePlayerState(_that.isPlaying);case _UpdateShuffleState() when updateShuffleState != null:
return updateShuffleState(_that.isShuffleModeEnabled);case _UpdateLoopState() when updateLoopState != null:
return updateLoopState(_that.loopMode);case _UpdateCurrentSong() when updateCurrentSong != null:
return updateCurrentSong(_that.song);case _SongFinished() when songFinished != null:
return songFinished();case _:
  return null;

}
}

}

/// @nodoc


class _InitMusicQueue implements MusicPlayerEvent {
  const _InitMusicQueue({required final  List<SongEntity> songs, required this.currentIndex}): _songs = songs;
  

 final  List<SongEntity> _songs;
 List<SongEntity> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}

 final  int currentIndex;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitMusicQueueCopyWith<_InitMusicQueue> get copyWith => __$InitMusicQueueCopyWithImpl<_InitMusicQueue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitMusicQueue&&const DeepCollectionEquality().equals(other._songs, _songs)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_songs),currentIndex);

@override
String toString() {
  return 'MusicPlayerEvent.initMusicQueue(songs: $songs, currentIndex: $currentIndex)';
}


}

/// @nodoc
abstract mixin class _$InitMusicQueueCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$InitMusicQueueCopyWith(_InitMusicQueue value, $Res Function(_InitMusicQueue) _then) = __$InitMusicQueueCopyWithImpl;
@useResult
$Res call({
 List<SongEntity> songs, int currentIndex
});




}
/// @nodoc
class __$InitMusicQueueCopyWithImpl<$Res>
    implements _$InitMusicQueueCopyWith<$Res> {
  __$InitMusicQueueCopyWithImpl(this._self, this._then);

  final _InitMusicQueue _self;
  final $Res Function(_InitMusicQueue) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? songs = null,Object? currentIndex = null,}) {
  return _then(_InitMusicQueue(
songs: null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongEntity>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _PlaySong implements MusicPlayerEvent {
  const _PlaySong({required this.song});
  

 final  SongEntity song;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaySongCopyWith<_PlaySong> get copyWith => __$PlaySongCopyWithImpl<_PlaySong>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaySong&&(identical(other.song, song) || other.song == song));
}


@override
int get hashCode => Object.hash(runtimeType,song);

@override
String toString() {
  return 'MusicPlayerEvent.playSong(song: $song)';
}


}

/// @nodoc
abstract mixin class _$PlaySongCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$PlaySongCopyWith(_PlaySong value, $Res Function(_PlaySong) _then) = __$PlaySongCopyWithImpl;
@useResult
$Res call({
 SongEntity song
});


$SongEntityCopyWith<$Res> get song;

}
/// @nodoc
class __$PlaySongCopyWithImpl<$Res>
    implements _$PlaySongCopyWith<$Res> {
  __$PlaySongCopyWithImpl(this._self, this._then);

  final _PlaySong _self;
  final $Res Function(_PlaySong) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? song = null,}) {
  return _then(_PlaySong(
song: null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as SongEntity,
  ));
}

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res> get song {
  
  return $SongEntityCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}

/// @nodoc


class _Pause implements MusicPlayerEvent {
  const _Pause();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pause);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.pause()';
}


}




/// @nodoc


class _Resume implements MusicPlayerEvent {
  const _Resume();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resume);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.resume()';
}


}




/// @nodoc


class _Seek implements MusicPlayerEvent {
  const _Seek(this.position);
  

 final  Duration position;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeekCopyWith<_Seek> get copyWith => __$SeekCopyWithImpl<_Seek>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Seek&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'MusicPlayerEvent.seek(position: $position)';
}


}

/// @nodoc
abstract mixin class _$SeekCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$SeekCopyWith(_Seek value, $Res Function(_Seek) _then) = __$SeekCopyWithImpl;
@useResult
$Res call({
 Duration position
});




}
/// @nodoc
class __$SeekCopyWithImpl<$Res>
    implements _$SeekCopyWith<$Res> {
  __$SeekCopyWithImpl(this._self, this._then);

  final _Seek _self;
  final $Res Function(_Seek) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(_Seek(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class _PreviousSong implements MusicPlayerEvent {
  const _PreviousSong();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousSong);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.playPreviousSong()';
}


}




/// @nodoc


class _NextSong implements MusicPlayerEvent {
  const _NextSong();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextSong);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.playNextSong()';
}


}




/// @nodoc


class _ToggleShuffle implements MusicPlayerEvent {
  const _ToggleShuffle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleShuffle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.toggleShuffle()';
}


}




/// @nodoc


class _CycleLoopMode implements MusicPlayerEvent {
  const _CycleLoopMode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleLoopMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.cycleLoopMode()';
}


}




/// @nodoc


class _UpdatePosition implements MusicPlayerEvent {
  const _UpdatePosition(this.position);
  

 final  Duration position;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePositionCopyWith<_UpdatePosition> get copyWith => __$UpdatePositionCopyWithImpl<_UpdatePosition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePosition&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'MusicPlayerEvent.updatePosition(position: $position)';
}


}

/// @nodoc
abstract mixin class _$UpdatePositionCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdatePositionCopyWith(_UpdatePosition value, $Res Function(_UpdatePosition) _then) = __$UpdatePositionCopyWithImpl;
@useResult
$Res call({
 Duration position
});




}
/// @nodoc
class __$UpdatePositionCopyWithImpl<$Res>
    implements _$UpdatePositionCopyWith<$Res> {
  __$UpdatePositionCopyWithImpl(this._self, this._then);

  final _UpdatePosition _self;
  final $Res Function(_UpdatePosition) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(_UpdatePosition(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class _UpdateDuration implements MusicPlayerEvent {
  const _UpdateDuration(this.duration);
  

 final  Duration duration;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDurationCopyWith<_UpdateDuration> get copyWith => __$UpdateDurationCopyWithImpl<_UpdateDuration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDuration&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,duration);

@override
String toString() {
  return 'MusicPlayerEvent.updateDuration(duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$UpdateDurationCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdateDurationCopyWith(_UpdateDuration value, $Res Function(_UpdateDuration) _then) = __$UpdateDurationCopyWithImpl;
@useResult
$Res call({
 Duration duration
});




}
/// @nodoc
class __$UpdateDurationCopyWithImpl<$Res>
    implements _$UpdateDurationCopyWith<$Res> {
  __$UpdateDurationCopyWithImpl(this._self, this._then);

  final _UpdateDuration _self;
  final $Res Function(_UpdateDuration) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? duration = null,}) {
  return _then(_UpdateDuration(
null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class _UpdatePlayerState implements MusicPlayerEvent {
  const _UpdatePlayerState(this.isPlaying);
  

 final  bool isPlaying;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePlayerStateCopyWith<_UpdatePlayerState> get copyWith => __$UpdatePlayerStateCopyWithImpl<_UpdatePlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePlayerState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying);

@override
String toString() {
  return 'MusicPlayerEvent.updatePlayerState(isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class _$UpdatePlayerStateCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdatePlayerStateCopyWith(_UpdatePlayerState value, $Res Function(_UpdatePlayerState) _then) = __$UpdatePlayerStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying
});




}
/// @nodoc
class __$UpdatePlayerStateCopyWithImpl<$Res>
    implements _$UpdatePlayerStateCopyWith<$Res> {
  __$UpdatePlayerStateCopyWithImpl(this._self, this._then);

  final _UpdatePlayerState _self;
  final $Res Function(_UpdatePlayerState) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,}) {
  return _then(_UpdatePlayerState(
null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _UpdateShuffleState implements MusicPlayerEvent {
  const _UpdateShuffleState(this.isShuffleModeEnabled);
  

 final  bool isShuffleModeEnabled;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateShuffleStateCopyWith<_UpdateShuffleState> get copyWith => __$UpdateShuffleStateCopyWithImpl<_UpdateShuffleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateShuffleState&&(identical(other.isShuffleModeEnabled, isShuffleModeEnabled) || other.isShuffleModeEnabled == isShuffleModeEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,isShuffleModeEnabled);

@override
String toString() {
  return 'MusicPlayerEvent.updateShuffleState(isShuffleModeEnabled: $isShuffleModeEnabled)';
}


}

/// @nodoc
abstract mixin class _$UpdateShuffleStateCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdateShuffleStateCopyWith(_UpdateShuffleState value, $Res Function(_UpdateShuffleState) _then) = __$UpdateShuffleStateCopyWithImpl;
@useResult
$Res call({
 bool isShuffleModeEnabled
});




}
/// @nodoc
class __$UpdateShuffleStateCopyWithImpl<$Res>
    implements _$UpdateShuffleStateCopyWith<$Res> {
  __$UpdateShuffleStateCopyWithImpl(this._self, this._then);

  final _UpdateShuffleState _self;
  final $Res Function(_UpdateShuffleState) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isShuffleModeEnabled = null,}) {
  return _then(_UpdateShuffleState(
null == isShuffleModeEnabled ? _self.isShuffleModeEnabled : isShuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _UpdateLoopState implements MusicPlayerEvent {
  const _UpdateLoopState(this.loopMode);
  

 final  int loopMode;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLoopStateCopyWith<_UpdateLoopState> get copyWith => __$UpdateLoopStateCopyWithImpl<_UpdateLoopState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLoopState&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode));
}


@override
int get hashCode => Object.hash(runtimeType,loopMode);

@override
String toString() {
  return 'MusicPlayerEvent.updateLoopState(loopMode: $loopMode)';
}


}

/// @nodoc
abstract mixin class _$UpdateLoopStateCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdateLoopStateCopyWith(_UpdateLoopState value, $Res Function(_UpdateLoopState) _then) = __$UpdateLoopStateCopyWithImpl;
@useResult
$Res call({
 int loopMode
});




}
/// @nodoc
class __$UpdateLoopStateCopyWithImpl<$Res>
    implements _$UpdateLoopStateCopyWith<$Res> {
  __$UpdateLoopStateCopyWithImpl(this._self, this._then);

  final _UpdateLoopState _self;
  final $Res Function(_UpdateLoopState) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loopMode = null,}) {
  return _then(_UpdateLoopState(
null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _UpdateCurrentSong implements MusicPlayerEvent {
  const _UpdateCurrentSong(this.song);
  

 final  SongEntity song;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCurrentSongCopyWith<_UpdateCurrentSong> get copyWith => __$UpdateCurrentSongCopyWithImpl<_UpdateCurrentSong>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCurrentSong&&(identical(other.song, song) || other.song == song));
}


@override
int get hashCode => Object.hash(runtimeType,song);

@override
String toString() {
  return 'MusicPlayerEvent.updateCurrentSong(song: $song)';
}


}

/// @nodoc
abstract mixin class _$UpdateCurrentSongCopyWith<$Res> implements $MusicPlayerEventCopyWith<$Res> {
  factory _$UpdateCurrentSongCopyWith(_UpdateCurrentSong value, $Res Function(_UpdateCurrentSong) _then) = __$UpdateCurrentSongCopyWithImpl;
@useResult
$Res call({
 SongEntity song
});


$SongEntityCopyWith<$Res> get song;

}
/// @nodoc
class __$UpdateCurrentSongCopyWithImpl<$Res>
    implements _$UpdateCurrentSongCopyWith<$Res> {
  __$UpdateCurrentSongCopyWithImpl(this._self, this._then);

  final _UpdateCurrentSong _self;
  final $Res Function(_UpdateCurrentSong) _then;

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? song = null,}) {
  return _then(_UpdateCurrentSong(
null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as SongEntity,
  ));
}

/// Create a copy of MusicPlayerEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res> get song {
  
  return $SongEntityCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}

/// @nodoc


class _SongFinished implements MusicPlayerEvent {
  const _SongFinished();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongFinished);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MusicPlayerEvent.songFinished()';
}


}




// dart format on
