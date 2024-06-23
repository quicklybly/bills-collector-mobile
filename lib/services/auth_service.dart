import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _keycloakUrl = 'http://${dotenv.get('hostname', fallback: '')}:8081';
  final String _realm = 'bills-collector';
  final String _clientId = dotenv.get('keycloak_user', fallback: '');
  final String _clientSecret = dotenv.get('keycloak_pass', fallback: '');

  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$_keycloakUrl/admin/realms/$_realm/users');
    final body = jsonEncode({
      'username': username,
      'enabled': true,
      'credentials': [
        {
          'type': 'password',
          'value': password,
          'temporary': false,
        },
      ],
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAdminToken()}',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to register user: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'username': username,
        'password': password,
      },
    );

    print(username);
    print(password);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to login: ${response.body}');
      return null;
    }
  }

  Future<String> _getAdminToken() async {
    final url = Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get admin token');
    }
  }
}
