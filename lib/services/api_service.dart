import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiResponse {
  final dynamic data;
  final Map<String, String> headers;

  ApiResponse(this.data, this.headers);
}

class ApiService {
  final String? baseUrl = dotenv.env['API_BASE_URL'];
  final String? _token = dotenv.env['API_TOKEN'];

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Expose-Headers': '*'
      };

  Future<ApiResponse> getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return ApiResponse(jsonDecode(response.body), response.headers);
      } else {
        throw Exception('''
          GET request failed:
          Status: ${response.statusCode}
          Body: ${response.body}
          Headers: ${response.headers}
          URL: $baseUrl/$endpoint
        ''');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ApiResponse> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
          final dynamic responseData =
              response.body.isNotEmpty ? jsonDecode(response.body) : null;
          return ApiResponse(responseData, response.headers);

        case 409:
          throw Exception('Entity already assigned to another entity');

        default:
          throw Exception(
              'POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<ApiResponse> putRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
          final dynamic responseData =
              response.body.isNotEmpty ? jsonDecode(response.body) : null;
          return ApiResponse(responseData, response.headers);

        case 409:
          throw Exception('Entity already assigned to another entity');

        default:
          throw Exception(
              'PUT request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<ApiResponse> patchRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
          final dynamic responseData =
              response.body.isNotEmpty ? jsonDecode(response.body) : null;
          return ApiResponse(responseData, response.headers);

        case 409:
          throw Exception('Entity already assigned to another entity');

        default:
          throw Exception(
              'PATCH request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<ApiResponse> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        final dynamic responseData =
            response.body.isNotEmpty ? jsonDecode(response.body) : null;
        return ApiResponse(responseData, response.headers);

      default:
        throw Exception(
            'PUT request failed with status: ${response.statusCode}');
    }
  }
}
