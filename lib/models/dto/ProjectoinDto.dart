import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
import 'package:cinema_reservations_front/models/dto/RoomDto.dart';

class Projection {
  final int projectionId;
  final Film film;
  final Room room;
  final String date;
  final String time;

  Projection({
    required this.projectionId,
    required this.film,
    required this.room,
    required this.date,
    required this.time,
  });


  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      projectionId: json['projectionId'],
      film: Film.fromJson(json['film']),
      room: Room.fromJson(json['room']),
      time: json['time']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}