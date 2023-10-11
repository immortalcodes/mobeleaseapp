import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart' as globals;

class AuthController {
  final String cookieKey = 'auth_cookie';
  final String baseUrl = globals.baseUrl;

  Future<bool> login(String email, String password, String role) async {
    var url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      body: jsonEncode({"email": email, "password": password, "role": role}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final cookies = response.headers['set-cookie'];
      print(cookies);
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (cookies != null) {
        // Store the received cookie (authentication token) using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(cookieKey, cookies);
        if (role == "employee") {
          int? empId = jsonResponse['data']['empid'];
          print(empId);
          prefs.setInt('empId', empId!);
        }

        return true;
      }
    }
    return false;
  }

//  verify user

  Future<void> verifiedUser(String token) async {
    var url = Uri.parse('$baseUrl/auth/verifyuser');
    final response = await http.post(
      url,
      headers: {'Cookie': token, 'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("User verified successfully");
      print("user: ${response.body}");
    } else {
      print("User not verified");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(cookieKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cookieKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<http.Response> postWithAuth(
      String path, Map<String, dynamic> body) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // Set the content type based on your API's requirements
      },
      body: jsonEncode(body), // Encode the request body as JSON
    );
    print("reponse ${response.body}");
    return response;
  }

  Future<http.Response> putWithAuth(
      String path, Map<String, dynamic> body) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // Set the content type based on your API's requirements
      },
      body: jsonEncode(body), // Encode the request body as JSON
    );

    return response;
  }

  Future<http.Response> deleteWithAuth(String path) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$path'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response;
  }
}
