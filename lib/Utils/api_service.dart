import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://passman.achyut.com.np/api/v1/';

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      // Add other headers like authorization here if needed
    };
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final Map<String, String> headers = await _getHeaders();

    try {
      final response = await http.get(uri, headers: headers);
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (error) {
      throw Exception('Failed to load data from the API');
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final Map<String, String> headers = await _getHeaders();

    try {
      final response = await http.post(uri, headers: headers, body: json.encode(data));
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (error) {
      throw Exception('Failed to send data to the API');
    }
  }

  // Add other HTTP methods as needed (PUT, DELETE, etc.)

  // You can create specific methods for each API endpoint you have
  static Future<Map<String, dynamic>> getUser(int userId) async {
    final String endpoint = '/users/$userId'; // Replace with your API endpoint
    return await get(endpoint);
  }

  // Add more methods for other API endpoints

  // Example of integrating your "Generated Passwords" endpoint
  static Future<Map<String, dynamic>> getGeneratedPasswords() async {
    final String endpoint = '/generated-passwords';
    return await get(endpoint);
  }

  static Future<Map<String, dynamic>> generateNewPassword(Map<String, dynamic> data) async {
    final String endpoint = '/generated-passwords/store';
    return await post(endpoint, data);
  }

// Add more methods for other endpoints
}
