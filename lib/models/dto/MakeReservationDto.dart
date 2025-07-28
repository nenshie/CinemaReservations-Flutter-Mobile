class MakeReservation {
  final String title;
  final String posterUrl;
  final int duration;

  MakeReservation({
    required this.title,
    required this.posterUrl,
    required this.duration,
  });

  factory MakeReservation.fromJson(Map<String, dynamic> json) {
    return MakeReservation(
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}