import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Model/LoginLog.dart';

class ApiService {
  static const baseUrl = 'https://passman.achyut.com.np/api/v1/';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
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
      return <String, dynamic>{'error': error.toString()};
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final Map<String, String> headers = await _getHeaders();

    try {
      final response = await http.post(uri, headers: headers, body: json.encode(data));
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        print("List");
        print(jsonResponse);
        return <String, dynamic>{'data': jsonResponse};
      } else if (jsonResponse is Map<String, dynamic>) {
        print("Map");
        print(jsonResponse);
        if (jsonResponse.containsKey('status')) {
          if (jsonResponse['status'] == 401) {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('_token');
            prefs.remove('user_data');
          }

          if (jsonResponse['status'] == 200) {
            final Map<String, dynamic> responseData = jsonResponse;
            return responseData;
          } else {
            return <String, dynamic>{'error': jsonResponse['message']};
          }
        }
        return <String, dynamic>{'data': jsonResponse};
      } else {
        print("Unexpected response format");
        return <String, dynamic>{'error': 'Unexpected response format'};
      }
    } catch (error) {
      print(error.toString());
      return <String, dynamic>{'error': error.toString()};
    }
  }
}
