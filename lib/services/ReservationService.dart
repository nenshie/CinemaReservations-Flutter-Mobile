import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String ipPort = "10.0.2.2:5215";
  static const String baseUrl = "http://$ipPort/api/reservation";


  Future<bool> makeReservation(int userId, int projectionId, List<Seat> seats) async {
    final url = Uri.parse(baseUrl);

    final seatsJson = seats.map((seat) => seat.toJson()).toList();

    final body = jsonEncode({
      'projectionId': projectionId,
      'userId': userId,
      'seats': seatsJson,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('--- RESERVATION POST LOG ---');
    print("URL: $url");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('----------------------------');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send reservation: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Projection>> fetchAllReservations() async {
    final uri = Uri.parse(baseUrl);

    final response = await http.get(uri);

    print('--- RESERVATION FETCH LOG ---');
    print("URL: $uri");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('----------------------------');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((projectionJson) => Projection.fromJson(projectionJson)).toList();
    } else {
      throw Exception("Failed to load reservations");
    }
  }
}
