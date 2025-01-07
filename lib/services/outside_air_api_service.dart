import 'dart:convert';
import 'package:envirosense/services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OutsideAirApiService {
  final String baseUrl = dotenv.env['WEATHER_API_BASE_URL']!;
  final String? _token = dotenv.env['WEATHER_API_KEY'];

  Future<ApiResponse> getRequest(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/current.json?key=$_token&q=$city&aqi=no'));
    if (response.statusCode == 200) {
      return ApiResponse(jsonDecode(response.body), response.headers);
    } else {
      throw Exception('GET request failed with status: ${response.statusCode}');
    }
  }
}
