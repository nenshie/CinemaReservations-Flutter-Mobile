class Film {
  final String title;
  final String posterUrl;
  final String time;
  final String date;
  final int duration;

  Film({
    required this.title,
    required this.posterUrl,
    required this.time,
    required this.date,
    required this.duration,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      time: json['time']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}