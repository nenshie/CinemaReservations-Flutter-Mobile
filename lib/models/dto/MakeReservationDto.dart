class Makereservation {
  final String title;
  final String posterUrl;
  final int duration;

  Makereservation({
    required this.title,
    required this.posterUrl,
    required this.duration,
  });

  factory Makereservation.fromJson(Map<String, dynamic> json) {
    return Makereservation(
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}