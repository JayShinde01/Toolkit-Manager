
import 'package:flutter/material.dart';
import 'package:toolkit_manager/core/widgets/common_app_bar.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/network/api_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {
    try {
      final response = await ApiClient().dio.post("/login", data: {
        "userName": username.text,
        "password": password.text,
      });

      if (!mounted) return;

      final token = response.data['token'];
      final role = response.data['role'];

      await SecureStorage.saveToken(token);

      if (!mounted) return;

      // Navigate based on role
      if (role == "ADMIN") {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else if (role == "LAB_ASSISTANT") {
        Navigator.pushReplacementNamed(context, "/labHome");
      } else {
        Navigator.pushReplacementNamed(context, "/studentHome");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Login"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: username, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}