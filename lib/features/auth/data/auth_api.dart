import '../../../core/network/api_client.dart';

class AuthApi {
  final api = ApiClient().dio;

  Future login(String username, String password) async {
    return await api.post("/login", data: {
      "userName": username,
      "password": password,
    });
  }

  Future register(Map<String, dynamic> data) async {
    return await api.post("/register", data: data);
  }
}