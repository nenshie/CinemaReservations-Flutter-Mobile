import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/models/dto/ReservationDto.dart';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String ipPort = "10.0.2.2:5215";
  static const String baseUrl = "http://$ipPort/api/reservation";


  Future<bool> makeReservation(String? userId, int projectionId, List<Seat> seats) async {
    final url = Uri.parse("$baseUrl/make");

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

  Future<List<Reservation>> getMyReservations(String userId) async {
    final uri = Uri.parse("$baseUrl/user/$userId");

    final response = await http.get(uri);

    print('--- GET MY RESERVATIONS LOG ---');
    print("URL: $uri");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('----------------------------');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((resJson) => Reservation.fromJson(resJson)).toList();
    } else {
      throw Exception("Failed to load user reservations");
    }
  }

  Future<bool> confirmReservationFromQr(String qrContent, String userId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5215/api/reservation/confirm-from-qr'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "qrContent": qrContent,
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Greška: ${response.body}');
      return false;
    }
  }

}
