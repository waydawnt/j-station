class RadioStation {
  const RadioStation({
    required this.name,
    required this.urlResolved,
    this.favicon,
    this.country,
    this.language,
  });

  final String name;
  final String urlResolved;
  final String? favicon;
  final String? country;
  final String? language;

  factory RadioStation.fromJson(Map json) {
    return RadioStation(
      name: json['name'] ?? 'Unknown Station',
      urlResolved: json['url_resolved'] ?? '',
      favicon: json['favicon'],
      country: json['country'],
      language: json['language'],
    );
  }
}
