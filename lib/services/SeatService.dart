import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;

class SeatService {
  static const String ipPort = "10.0.2.2:5215";
  static const String baseUrl = "http://$ipPort/api/seat";

  Future<List<Seat>> fetchAllSeatsForRoom(int roomId, int filmId) async {

    final queryParameters = {
      'roomId': roomId,
      'filmId': filmId
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((seatJson) => Seat.fromJson(seatJson)).toList();
    } else {
      throw Exception("Failed to load seats for roomId:$roomId");
    }
  }

  Future<List<Seat>> fetchSeatsWithAvailability(int projectionId) async {
    final uri = Uri.parse('http://10.0.2.2:5215/api/seat/availability')
        .replace(queryParameters: {'projectionId': projectionId.toString()});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Seat.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch seats");
    }
  }

}