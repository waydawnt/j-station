import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import 'package:j_station/models/podcast.dart';
import 'package:j_station/providers/audio_provider.dart';
import 'package:j_station/services/audio_handler.dart';

class PodcastDetails extends ConsumerWidget {
  const PodcastDetails({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = ref.watch(podcastEpisodesProvider(podcast.feedUrl));

    return Scaffold(
      appBar: AppBar(title: Text(podcast.trackName)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: podcast.artworkUrl600,
                  width: 100,
                  height: 100,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.podcasts, size: 100),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast.trackName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        podcast.artistName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: episodes.when(
              data: (episodeList) {
                if (episodeList.isEmpty) {
                  return const Center(child: Text('No episodes available.'));
                }

                return ListView.builder(
                  itemCount: episodeList.length,
                  itemBuilder: (context, index) {
                    final episode = episodeList[index];
                    final isPlaying =
                        ref.watch(currentPlayingProvider).url ==
                        episode.audioUrl;

                    return ListTile(
                      leading: isPlaying
                          ? LottieBuilder.network(
                              'https://lottie.host/ebdc7d77-e5c4-4020-8a53-11823bec3aa8/6UZS5XtXoO.json',
                            )
                          : const Icon(Icons.play_circle_outline),
                      title: Text(
                        episode.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        episode.pubDate,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () async {
                        final handler =
                            ref.read(audioHandlerProvider) as MyAudioHandler;

                        ref
                            .read(currentPlayingProvider.notifier)
                            .setPlaying(
                              title: episode.title,
                              url: episode.audioUrl,
                            );

                        await handler.playFromUrl(
                          url: episode.audioUrl,
                          title: episode.title,
                          artist: podcast.trackName,
                          artUri: podcast.artworkUrl600,
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
