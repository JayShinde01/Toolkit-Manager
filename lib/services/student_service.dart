import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/storage_service.dart';

class StudentService {

  static Future<bool> updateProfile(Map<String, dynamic> body) async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId(); // must exist

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/student/$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }
  static Future<Map<String, dynamic>?> getProfile() async {
  final token = await StorageService.getToken();
  final userId = await StorageService.getUserId();

  final response = await http.get(
    Uri.parse("${ApiConstants.baseUrl}/api/student/$userId"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return null;
}
}
