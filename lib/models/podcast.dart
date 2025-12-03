class Podcast {
  final String trackName;
  final String artistName;
  final String artworkUrl600;
  final String feedUrl;
  final String? collectionViewUrl;

  Podcast({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl600,
    required this.feedUrl,
    this.collectionViewUrl,
  });

  factory Podcast.fromJson(Map json) {
    return Podcast(
      trackName: json['trackName'] ?? 'Unknown Podcast',
      artistName: json['artistName'] ?? 'Unknown Artist',
      artworkUrl600: json['artworkUrl600'] ?? '',
      feedUrl: json['feedUrl'] ?? '',
      collectionViewUrl: json['collectionViewUrl'],
    );
  }
}

class PodcastEpisode {
  final String title;
  final String description;
  final String pubDate;
  final String audioUrl;

  PodcastEpisode({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.audioUrl,
  });
}
