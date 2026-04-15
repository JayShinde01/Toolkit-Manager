import 'dart:convert';
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
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  // 🔥 JWT PARSER
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid JWT token");
    }

    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    return jsonDecode(decoded);
  }

  // 🔥 LOGIN FUNCTION
  Future<void> login() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter username & password")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      print("🔥 Login clicked");
      print("➡️ Username: ${username.text}");

      final response = await ApiClient().dio.post(
        "/login",
        data: {
          "userName": username.text,
          "password": password.text,
        },
      );

      print("✅ Raw Response: ${response.data}");

      if (!mounted) return;

      // 🔥 FIX: response is STRING JWT
      final String token = response.data.toString();

      print("🔐 JWT Token: $token");

      // Save token
      await SecureStorage.saveToken(token);

      // 🔥 Extract role from JWT
      final payload = parseJwt(token);
      final role = payload['role'];

      print("👤 Role from JWT: $role");

      if (!mounted) return;

      // 🔥 ROLE BASED NAVIGATION
      if (role == "ADMIN") {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else if (role == "LAB_ASSISTANT") {
        Navigator.pushReplacementNamed(context, "/labHome");
      } else if (role == "STUDENT") {
        Navigator.pushReplacementNamed(context, "/studentHome");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown role: $role")),
        );
      }
    } catch (e) {
      print("❌ Login ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  // 🔥 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Login"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}