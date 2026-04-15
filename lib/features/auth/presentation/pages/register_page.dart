import 'package:flutter/material.dart';
import 'package:toolkit_manager/core/widgets/common_app_bar.dart';
import 'package:toolkit_manager/core/network/api_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String role = "STUDENT";
  bool isLoading = false;

  // 🔥 REGISTER FUNCTION WITH FULL DEBUG
  Future<void> register() async {
    // ✅ Validation
    if (username.text.isEmpty ||
        password.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      print("🔥 Register button clicked");

      print("➡️ Sending Data:");
      print("Username: ${username.text}");
      print("Password: ${password.text}");
      print("Role: $role");
      print("Email: ${email.text}");
      print("Phone: ${phone.text}");

      final response = await ApiClient().dio.post(
        "/register",
        data: {
          "userName": username.text,
          "password": password.text,
          "role": role,
          "email": email.text,
          "phone": phone.text,
        },
      );

      print("✅ Response Received");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered Successfully")),
        );

        // 👉 Navigate to login (recommended)
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected response: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("❌ ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
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
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  // 🔥 UI DESIGN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Register"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Username
            TextField(
              controller: username,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Email
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Phone
            TextField(
              controller: phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(
                labelText: "Select Role",
                border: OutlineInputBorder(),
              ),
              items: ["STUDENT", "ADMIN", "LAB_ASSISTANT"]
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : register,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register"),
              ),
            ),

            const SizedBox(height: 10),

            // Navigate to Login
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Already have account? Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}