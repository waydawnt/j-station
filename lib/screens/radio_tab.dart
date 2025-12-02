import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import 'package:j_station/providers/audio_provider.dart';
import 'package:j_station/services/audio_handler.dart';
import 'package:j_station/widgets/banner_ad_widget.dart';

class RadioTab extends ConsumerWidget {
  const RadioTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radioStations = ref.watch(radioStationProvider);

    return radioStations.when(
      data: (stations) {
        if (stations.isEmpty) {
          return const Center(child: Text('No radio stations found.'));
        }

        return ListView.builder(
          itemCount: stations.length + 1,
          itemBuilder: (context, index) {
            if (index == stations.length) {
              return Container(
                height: 50,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: BannerAdWidget()),
              );
            }

            final station = stations[index];
            final isPlaying =
                ref.watch(currentPlayingProvider).url == station.urlResolved;

            return ListTile(
              leading: station.favicon != null && station.favicon!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: station.favicon!,
                      width: 40,
                      height: 40,
                      placeholder: (context, url) => const Icon(Icons.radio),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.radio),
                    )
                  : const Icon(Icons.radio, size: 40),
              title: Text(
                station.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${station.language ?? ''} • ${station.country ?? ''}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              trailing: isPlaying
                  ? LottieBuilder.network(
                      'https://lottie.host/e64bee29-8553-4725-bd32-6beea2152f91/yzGLDF0tvi.json',
                      width: 40,
                    )
                  : const Icon(Icons.play_circle_outline),
              onTap: () async {
                final handler =
                    ref.read(audioHandlerProvider) as MyAudioHandler;

                ref
                    .read(currentPlayingProvider.notifier)
                    .setPlaying(
                      title: station.name,
                      url: station.urlResolved,
                      subtitle: station.country,
                      artworkUrl: station.favicon,
                    );

                await handler.playFromUrl(
                  url: station.urlResolved,
                  title: station.name,
                  artist: 'Radio • ${station.country ?? 'Japan'}',
                  artUri: station.favicon,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
