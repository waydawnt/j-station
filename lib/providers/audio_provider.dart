import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:j_station/services/api_service.dart';
import 'package:j_station/models/radio_station.dart';
import 'package:j_station/services/audio_handler.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final radioStationProvider = FutureProvider<List<RadioStation>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchStations();
});

final currentMediaProvider = StreamProvider((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.mediaItem;
});

final playbackStateProvider = StreamProvider((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.playbackState;
});

final isPlayingProvider = Provider((ref) {
  final playbackState = ref.watch(playbackStateProvider);
  return playbackState.maybeWhen(
    data: (state) => state.playing,
    orElse: () => false,
  );
});

class CurrentPlayingNotifier extends StateNotifier {
  CurrentPlayingNotifier() : super(CurrentPlayingState.initial());

  void setPlaying({
    required String title,
    required String url,
    String? subtitle,
    String? artworkUrl,
  }) {
    state = CurrentPlayingState(
      title: title,
      url: url,
      subtitle: subtitle,
      artworkUrl: artworkUrl,
      isPlaying: true,
    );
  }

  void clear() {
    state = CurrentPlayingState.initial();
  }
}

final currentPlayingProvider = StateNotifierProvider(
  (ref) => CurrentPlayingNotifier(),
);

class CurrentPlayingState {
  const CurrentPlayingState({
    required this.title,
    required this.url,
    this.subtitle,
    this.artworkUrl,
    this.isPlaying = false,
  });

  final String title;
  final String url;
  final String? subtitle;
  final String? artworkUrl;
  final bool isPlaying;

  factory CurrentPlayingState.initial() =>
      CurrentPlayingState(title: '', url: '', isPlaying: false);

  bool get hasContent => title.isNotEmpty;
}
