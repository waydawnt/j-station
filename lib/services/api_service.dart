import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';

import 'package:j_station/models/radio_station.dart';
import 'package:j_station/models/podcast.dart';

class ApiService {
  static const String radioApiUrl =
      'https://de1.api.radio-browser.info/json/stations/bycountrycodeexact/JP';

  static const String podcastApiUrl =
      'https://itunes.apple.com/search?term=podcast&country=JP&media=podcast&limit=50';

  Future<List<RadioStation>> fetchStations() async {
    try {
      final response = await http.get(Uri.parse(radioApiUrl));

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        final Set<String> seenUrls = {};
        return jsonData.map((json) => RadioStation.fromJson(json)).where((
          station,
        ) {
          final url = station.urlResolved;
          final isUrlValid = url.isNotEmpty;
          final lastCheckOk = station.lastCheckOk;
          final isLanguageMatch =
              station.language == 'japanese' || station.language == 'english';
          final isUnique = !seenUrls.contains(url);

          if (isUrlValid && isLanguageMatch && isUnique && lastCheckOk != 0) {
            seenUrls.add(url);
            return true;
          }
          return false;
        }).toList();
      } else {
        throw Exception('Failed to load radio stations');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Podcast>> fetchPodcasts() async {
    try {
      final response = await http.get(Uri.parse(podcastApiUrl));

      if (response.statusCode == 200) {
        final Map jsonData = json.decode(response.body);
        final List results = jsonData['results'] ?? [];

        return results.map((json) => Podcast.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load podcasts.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PodcastEpisode>> fetchPodcastEpisodes(String feedUrl) async {
    try {
      final response = await http.get(Uri.parse(feedUrl));

      if (response.statusCode == 200) {
        final rssFeed = RssFeed.parse(response.body);

        final List<PodcastEpisode> episodes =
            rssFeed.items
                ?.take(5)
                .map((item) {
                  final audioUrl = item.enclosure?.url ?? '';

                  return PodcastEpisode(
                    title: item.title ?? 'Untitled Episode',
                    description: item.description ?? '',
                    pubDate: item.pubDate.toString(),
                    audioUrl: audioUrl,
                  );
                })
                .where((episode) => episode.audioUrl.isNotEmpty)
                .toList() ??
            [];

        return episodes;
      } else {
        throw Exception('Failed to load podcast episodes');
      }
    } catch (e) {
      rethrow;
    }
  }
}
