import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/api_result.dart';
import '../models/rental.dart';
import '../models/user.dart';
import '../models/vehicle.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  //  Auth credentials 
  // Stored after a successful login so authenticated endpoints can
  // send HTTP Basic auth headers with every request.

  static String? _email;
  static String? _password;
  static User? currentUser;

  static Map<String, String> get _authHeaders {
    if (_email == null || _password == null) return {};
    final credentials = base64Encode(utf8.encode('$_email:$_password'));
    return {'Authorization': 'Basic $credentials'};
  }

  static void clearSession() {
    _email = null;
    _password = null;
    currentUser = null;
  }

  //  Auth endpoints 

  static Future<ApiResult<User>> register({
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
        return ApiResult.success(User.fromJson(decoded));
      }

      final message = decoded['error'] ?? decoded['message'] ?? 'Registration failed';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }

  static Future<ApiResult<User>> login({
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
        final user = User.fromJson(decoded);
        // Store credentials for authenticated calls
        _email = email;
        _password = password;
        currentUser = user;
        return ApiResult.success(user);
      }

      final message = decoded['error'] ?? decoded['message'] ?? 'Login failed';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }

  // Vehicle endpoints 

  /// Fetches all vehicles from the backend.
  /// TODO: Backend team needs to add GET /api/vehicles endpoint.
  static Future<ApiResult<List<Vehicle>>> getVehicles() async {
    final uri = Uri.parse('$baseUrl/api/vehicles');

    try {
      final response = await http.get(
        uri,
        headers: {..._authHeaders},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final vehicles = jsonList
            .map((json) => Vehicle.fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResult.success(vehicles);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final message = decoded['error'] ?? decoded['message'] ?? 'Failed to load vehicles';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }

  //  Rental endpoints 

  static Future<ApiResult<Rental>> rent({
    required int vehicleId,
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse('$baseUrl/api/rentals');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ..._authHeaders,
        },
        body: jsonEncode({
          'vehicleId': vehicleId,
          'startDate': startDate,
          'endDate': endDate,
        }),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return ApiResult.success(Rental.fromJson(decoded));
      }

      final message = decoded['error'] ?? decoded['message'] ?? 'Rental failed';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }

  static Future<ApiResult<List<Rental>>> getRentals(int userId) async {
    final uri = Uri.parse('$baseUrl/api/rentals/$userId');

    try {
      final response = await http.get(
        uri,
        headers: {..._authHeaders},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final rentals = jsonList
            .map((json) => Rental.fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResult.success(rentals);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final message = decoded['error'] ?? decoded['message'] ?? 'Failed to load rentals';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }

  static Future<ApiResult<Rental>> returnVehicle(int rentalId) async {
    final uri = Uri.parse('$baseUrl/api/rentals/$rentalId/return');

    try {
      final response = await http.post(
        uri,
        headers: {..._authHeaders},
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ApiResult.success(Rental.fromJson(decoded));
      }

      final message = decoded['error'] ?? decoded['message'] ?? 'Return failed';
      return ApiResult.failure(message);
    } catch (e) {
      return const ApiResult.failure(
        'Could not connect to the server. Please try again later.',
      );
    }
  }
}
