import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/bill.dart';
import '../model/usages.dart';
import 'auth_service.dart';

class BillsService {
  final String _baseUrl = 'http://${dotenv.get('hostname', fallback: '')}:8080/bills-collector';

  Future<List<Bill>> fetchBills() async {
    AuthService authService = AuthService();
    String? token = await authService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/bills');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((bill) => Bill.fromJson(bill)).toList();
    } else {
      throw Exception('Failed to load bills');
    }
  }

  Future<Bill> createBill(String name, String description, String token) async {
    final url = Uri.parse('$_baseUrl/bills');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Bill.fromJson(data);
    } else {
      throw Exception('Failed to create bill');
    }
  }

  Future<Usages> createUsage(int billId, Usages usage, String token) async {
    final url = Uri.parse('$_baseUrl/bills/$billId/usages');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'count_date': usage.countDate.toIso8601String(),
        'usage': usage.usage,
        'bill_id': usage.billId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Usages.fromJson(data);
    } else {
      throw Exception('Failed to create usage');
    }
  }

  Future<String> fetchAdvise(int billId, String token) async {
    final url = Uri.parse('$_baseUrl/bills/$billId/advice');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Failed to load advise');
    }
  }

  Future<Bill> editBill(int id, String name, String description, String token) async {
    final url = Uri.parse('$_baseUrl/bills/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Bill.fromJson(data);
    } else {
      throw Exception('Failed to edit bill');
    }
  }

  Future<void> deleteBill(int id, String token) async {
    final url = Uri.parse('$_baseUrl/bills/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete bill');
    }
  }

  Future<List<Usages>> fetchUsages(int billId, String token) async {
    final url = Uri.parse('$_baseUrl/bills/$billId/usages');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((usage) => Usages.fromJson(usage)).toList();
    } else {
      throw Exception('Failed to load usages');
    }
  }
}
