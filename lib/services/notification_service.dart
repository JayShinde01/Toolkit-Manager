import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/storage_service.dart';

class NotificationService {

  // GET ALL NOTIFICATIONS
  static Future<List<dynamic>> getNotifications() async {
    final token = await StorageService.getToken();
    final userId = await StorageService.getUserId();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/notifications/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // GET UNREAD COUNT
  static Future<int> getUnreadCount() async {
    final data = await getNotifications();

    return data.where((n) => n["read"] == false).length;
  }
  static Future<bool> markAsRead(int notificationId) async {
  final token = await StorageService.getToken();

  final response = await http.put(
    Uri.parse("${ApiConstants.baseUrl}/api/notifications/read/$notificationId"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  return response.statusCode == 200;
}
}