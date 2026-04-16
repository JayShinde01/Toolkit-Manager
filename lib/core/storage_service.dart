import 'package:shared_preferences/shared_preferences.dart';
class StorageService {

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }
  static Future<void> saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("userName", name);
}

static Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("userName");
}
}