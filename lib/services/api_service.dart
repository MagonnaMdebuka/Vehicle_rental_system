import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  /// Registers a new user. Returns a map with either:
  /// - `{ "success": true, "data": { "id": ..., "fullName": ..., "email": ... } }`
  /// - `{ "success": false, "message": "..." }`
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    String? phone,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');

    final body = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'password': password,
    };
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'success': true, 'data': decoded};
      }

      // 409 conflict (email taken) or 400 validation error
      final message = decoded['message'] ?? 'Registration failed';
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to the server. Please try again later.',
      };
    }
  }

  /// Logs in a user. Returns a map with either:
  /// - `{ "success": true, "data": { "id": ..., "fullName": ..., "email": ... } }`
  /// - `{ "success": false, "message": "..." }`
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'success': true, 'data': decoded};
      }

      final message = decoded['message'] ?? 'Login failed';
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to the server. Please try again later.',
      };
    }
  }
}
