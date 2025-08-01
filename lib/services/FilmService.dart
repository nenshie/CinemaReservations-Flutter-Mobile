import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
class FilmService {
  static const String ipPort = "172.20.10.5:5215";
  static const String baseUrl = "http://$ipPort/api/film";

  static Future<List<Film>> fetchAllFilms(int pageSize) async {

    final queryParameters = {
      'filterBy': 'genre',
      'filterValue': 'action',
      'sortBy': 'Time',
      'ascending': 'true',
      'pageNumber': '1',
      'pageSize': pageSize.toString(),
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    final response = await http.get(uri);
    // print('--- FILM FETCH LOG ---');
    // print("URL: $uri");
    // print("Status code: ${response.statusCode}");
    // print("Response body: ${response.body}");
    // print('------------------------');
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((filmJson) => Film.fromJson(filmJson)).toList();
    } else {
      throw Exception("Failed to load films");
    }
  }
}