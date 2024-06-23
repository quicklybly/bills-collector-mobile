import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as logDev;



import '../model/bills.dart';

class AuthService {
  final String _keycloakUrl = 'http://${dotenv.get('hostname', fallback: '')}/auth';
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
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
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


    logDev.log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      return data;
    } else {
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get admin token');
    }
  }
}
