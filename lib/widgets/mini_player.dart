import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:j_station/providers/audio_provider.dart';
import 'package:j_station/services/audio_handler.dart';
import 'package:j_station/screens/full_player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlaying = ref.watch(currentPlayingProvider);
    final playbackState = ref.watch(playbackStateProvider);

    if (!currentPlaying.hasContent) {
      return const SizedBox.shrink();
    }

    final isPlaying = playbackState.maybeWhen(
      data: (state) => state.playing,
      orElse: () => false,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FullPlayerScreen()),
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Artwork
            if (currentPlaying.artworkUrl != null)
              CachedNetworkImage(
                imageUrl: currentPlaying.artworkUrl!,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.music_note, size: 40),
              )
            else
              const SizedBox(
                width: 70,
                height: 70,
                child: Icon(Icons.music_note, size: 40),
              ),

            // Title and subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentPlaying.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (currentPlaying.subtitle != null)
                      Text(
                        currentPlaying.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Play/Pause button
            IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 40,
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
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
