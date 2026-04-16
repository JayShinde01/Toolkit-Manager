import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/storage_service.dart';

class AdminService {

  // ================= GET PROFILE =================
  static Future<Map<String, dynamic>?> getProfile() async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // ================= UPDATE PROFILE =================
  static Future<bool> updateProfile(Map<String, dynamic> body) async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  // ================= REJECT REQUEST =================
  static Future<bool> rejectRequest(int issueId) async {
    final token = await StorageService.getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkitissue/update/$issueId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "status": "REJECTED"
      }),
    );

    return response.statusCode == 200;
  }

  // ================= ADD TOOLKIT =================
  static Future<bool> addToolkit(Map<String, dynamic> body) async {
    final token = await StorageService.getToken();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkit/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ================= UPDATE TOOLKIT =================
  static Future<bool> updateToolkit(int id, Map<String, dynamic> body) async {
    final token = await StorageService.getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkit/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }
}