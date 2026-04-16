import 'package:flutter/material.dart';
import 'package:toolkit_manager/screens/auth/register_screen.dart';
import '../../services/auth_service.dart';
import '../student/student_home.dart';
import '../admin/admin_home.dart';
import '../lab/lab_home.dart';
import '../../core/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final userController = TextEditingController();
  final passController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    bool success = await AuthService.login(
      userController.text.trim(),
      passController.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      String? role = await StorageService.getRole();

      if (role == "STUDENT") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => StudentHome()));
      } else if (role == "ADMIN") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AdminHome()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LabHome()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Username or Password ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [

                const Icon(Icons.lock, size: 80, color: Colors.blue),

                const SizedBox(height: 20),

                const Text(
                  "Login",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                // Username
                TextFormField(
                  controller: userController,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter username" : null,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter password" : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),
                ),

                const SizedBox(height: 10),

                // Register
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Don't have account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}