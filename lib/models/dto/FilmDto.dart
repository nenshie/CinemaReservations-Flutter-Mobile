class Film {
  final String title;
  final String posterUrl;
  final int duration;

  Film({
    required this.title,
    required this.posterUrl,
    required this.duration,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}