import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://94.130.75.173:8101';

  Future<dynamic> getRequest(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri.parse('$baseUrl/$endpoint');

    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET request failed with status: ${response.statusCode}');
    }
  }

  Future<dynamic> postRequest(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST request failed with status: ${response.statusCode}');
    }
  }
}