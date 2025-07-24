import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
class ProjectionService {
  static const String ipPort = "10.0.2.2:5215";
  static const String baseUrl = "http://$ipPort/api/projection";

  Future<List<Projection>> fetchAllProjectoins() async {

    final uri = Uri.parse(baseUrl);

    final response = await http.get(uri);

    print('--- PROJECTION FETCH LOG ---');
    print("URL: $uri");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('------------------------');
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((projectionJson) => Projection.fromJson(projectionJson)).toList();
    } else {
      throw Exception("Failed to load projections");
    }
  }
}