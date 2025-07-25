class Film {
  final int filmId;
  final String title;
  final String posterUrl;
  final int duration;

  Film({
    required this.filmId,
    required this.title,
    required this.posterUrl,
    required this.duration,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      filmId: json['filmId'],
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}