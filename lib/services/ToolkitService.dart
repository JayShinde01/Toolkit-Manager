import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/storage_service.dart';

class ToolkitService {

  // ================= GET ALL KITS =================
  static Future<List<dynamic>> getAllKits() async {
    final token = await StorageService.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkit/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    print("GET KITS: ${response.statusCode}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // ================= REQUEST TOOLKIT =================
  static Future<bool> requestToolkit(int toolkitId) async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId();

    final url = Uri.parse(
        "${ApiConstants.baseUrl}/api/toolkitissue/request/$userId/$toolkitId");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("REQUEST TOOLKIT: ${response.statusCode}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ================= GET MY REQUESTS (HISTORY) =================
  static Future<List<dynamic>> getMyRequests() async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkitissue/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("GET MY REQUESTS: ${response.statusCode}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // ================= GET ALL REQUESTS (ADMIN) =================
  static Future<List<dynamic>> getAllRequests() async {
    final token = await StorageService.getToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkitissue/"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("GET ALL REQUESTS: ${response.statusCode}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // ================= APPROVE REQUEST =================
  static Future<bool> approveRequest(int issueId) async {
    final token = await StorageService.getToken();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkitissue/approve/$issueId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("APPROVE: ${response.statusCode}");

    return response.statusCode == 200;
  }

  // ================= DELETE REQUEST =================
  static Future<bool> deleteRequest(int issueId) async {
    final token = await StorageService.getToken();

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/api/toolkitissue/delete/$issueId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE: ${response.statusCode}");

    return response.statusCode == 200;
  }
}