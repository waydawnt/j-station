import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioHandlerProvider = Provider<AudioHandler>((ref) {
  throw UnimplementedError('audioHandlerProvider must be overriden');
});

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _player.playbackEventStream.map((_transformEvent)).pipe(playbackState);

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
      }
    });
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: 0,
    );
  }

  @override
  Future play() => _player.play();

  @override
  Future pause() => _player.pause();

  @override
  Future stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future seek(Duration position) => _player.seek(position);

  @override
  Future playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);

    try {
      await _player.setUrl(mediaItem.id);
      play();
    } catch (e) {
      throw 'Error: $e';
    }
  }

  Future playFromUrl({
    required String url,
    required String title,
    String? artist,
    String? artUri,
  }) async {
    final mediaItem = MediaItem(
      id: url,
      title: title,
      artist: artist ?? 'Japanese Radio',
      artUri: artist != null ? Uri.parse(artUri!) : null,
    );

    await playMediaItem(mediaItem);
  }

  @override
  Future onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }
}
