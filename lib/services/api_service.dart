import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiResponse {
  final dynamic data;
  final Map<String, String> headers;

  ApiResponse(this.data, this.headers);
}

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final String? _token = dotenv.env['API_TOKEN'];

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  Future<ApiResponse> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ApiResponse(jsonDecode(response.body), response.headers);
    } else {
      throw Exception('GET request failed with status: ${response.statusCode}');
    }
  }

  Future<ApiResponse> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );

    print('Raw Headers: ${response.headers}');
    print('All Headers:');
    response.headers.forEach((key, value) {
      print('$key: $value');
    });

    return ApiResponse(jsonDecode(response.body), response.headers);
  }
}
