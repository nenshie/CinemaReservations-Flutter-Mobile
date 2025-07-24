import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
import 'package:cinema_reservations_front/models/dto/RoomDto.dart';

class Projection {
  final Film film;
  final Room room;
  final String date;
  final String time;

  Projection({
    required this.film,
    required this.room,
    required this.date,
    required this.time,
  });


  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      film: Film.fromJson(json['film']),
      room: Room.fromJson(json['room']),
      time: json['time']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}