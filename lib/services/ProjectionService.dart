import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ProjectionService {
  static const String ipPort = "172.20.10.5:5215";
  static const String baseUrl = "http://$ipPort/api/projection";

  Future<List<Projection>> fetchAllProjectoins() async {

    final uri = Uri.parse(baseUrl);

    final response = await http.get(uri);

    // print('--- PROJECTION FETCH LOG ---');
    // print("URL: $uri");
    // print("Status code: ${response.statusCode}");
    // print("Response body: ${response.body}");
    // print('------------------------');
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((projectionJson) => Projection.fromJson(projectionJson)).toList();
    } else {
      throw Exception("Failed to load projections");
    }
  }

  static Future<bool> addProjection({
    required int filmId,
    required int roomId,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    final uri = Uri.parse(baseUrl);

    final projectionDate = DateTime(date.year, date.month, date.day);

    final projectionTime = DateTime(1, 1, 1, time.hour, time.minute);

    final payload = {
      "filmId": filmId,
      "roomId": roomId,
      "date": projectionDate.toIso8601String(),
      "time": projectionTime.toIso8601String(),
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("POST Projection => ${response.statusCode}");
    print(response.body);

    return response.statusCode == 201;
  }
}