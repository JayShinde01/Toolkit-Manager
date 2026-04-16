import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {


static Future<bool> login(String userName, String password) async {
  final url = Uri.parse("${ApiConstants.baseUrl}/login");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userName": userName,
      "password": password
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

   await StorageService.saveToken(data["token"]);
await StorageService.saveRole(data["role"]);
await StorageService.saveUserId(data["userId"].toString());
await StorageService.saveUserName(data["userName"]); // 🔥 ADD THIS

    return true;
  }

  return false;
}
  // REGISTER
  static Future<bool> register(Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}