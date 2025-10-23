import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'http://192.168.12.49:8000'; // Replace with your backend URL

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;

  AuthResponse({required this.accessToken, required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

class User {
  final int id;
  final String email;
  final bool isActive;

  User({required this.id, required this.email, required this.isActive});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      isActive: json['is_active'],
    );
  }
}
