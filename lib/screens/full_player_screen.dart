import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_gradient/animate_gradient.dart';

import 'package:j_station/providers/audio_provider.dart';
import 'package:j_station/services/audio_handler.dart';
import 'package:j_station/widgets/banner_ad_widget.dart';

class FullPlayerScreen extends ConsumerStatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  ConsumerState<FullPlayerScreen> createState() => _FullScreenState();
}

class _FullScreenState extends ConsumerState<FullPlayerScreen> {
  final List<Color> vibrantPrimaryColors = [
    const Color(0xFFC4302B), // Deep Crimson Red
    const Color(0xFF5E35B1), // Deep Purple (vibrant)
    const Color(0xFF00B0FF), // Bright Blue/Sky Blue
  ];
  final List<Color> vibrantSecondaryColors = [
    const Color(0xFFFFB300), // Bright Gold/Amber
    const Color(0xFFF44336), // Tomato Red/Coral
    const Color(0xFF00E676), // Bright Green/Emerald
  ];

  @override
  Widget build(BuildContext context) {
    final currentPlaying = ref.watch(currentPlayingProvider);
    final playbackState = ref.watch(playbackStateProvider);

    final isPlaying = playbackState.maybeWhen(
      data: (state) => state.playing,
      orElse: () => false,
    );

    Widget screenContent = Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + 25,
            left: 8,
            right: 8,
            bottom: 8,
          ),
          child: Center(child: BannerAdWidget()),
        ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: currentPlaying.artworkUrl != null
                        ? CachedNetworkImage(
                            imageUrl: currentPlaying.artworkUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.music_note,
                              size: 120,
                              color: Colors.white70,
                            ),
                          )
                        : Container(
                            color: Colors.black38,
                            child: const Icon(
                              Icons.music_note,
                              size: 120,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    currentPlaying.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // High contrast text on dark gradient
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (currentPlaying.subtitle != null)
                  Text(
                    currentPlaying.subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Slightly lighter contrast
                    ),
                  ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 80,
                    color: Colors.white, // White icon for maximum contrast
                  ),
                  onPressed: () async {
                    final handler = ref.read(audioHandlerProvider);
                    if (isPlaying) {
                      await handler.pause();
                    } else {
                      await handler.play();
                    }
                  },
                ),
                const SizedBox(height: 20),
                // ... (Playback State text remains the same, update its color for contrast)
                playbackState.when(
                  data: (state) {
                    String statusText = '';
                    switch (state.processingState) {
                      case AudioProcessingState.loading:
                        statusText = 'Loading...';
                        break;
                      case AudioProcessingState.buffering:
                        statusText = 'Buffering...';
                        break;
                      case AudioProcessingState.ready:
                        statusText = state.playing ? 'Playing' : 'Paused';
                        break;
                      default:
                        statusText = 'Stopped';
                    }

                    return Text(
                      statusText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Now Playing', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimateGradient(
            primaryBegin: Alignment.topLeft,
            primaryEnd: Alignment.center,
            secondaryBegin: Alignment.bottomRight,
            secondaryEnd: Alignment.topCenter,
            primaryColors: vibrantPrimaryColors,
            secondaryColors: vibrantSecondaryColors,
            duration: const Duration(seconds: 18),
          ),
          screenContent,
        ],
      ),
    );
  }
}
