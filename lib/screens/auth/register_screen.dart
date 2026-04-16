import 'package:flutter/material.dart';
import 'package:toolkit_manager/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final formKey = GlobalKey<FormState>();

  final user = TextEditingController();
  final pass = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  String role = "STUDENT";
  bool isLoading = false;

  void register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    bool success = await AuthService.register({
      "userName": user.text.trim(),
      "password": pass.text.trim(),
      "role": role,
      "email": email.text.trim(),
      "phone": phone.text.trim()
    });

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registered Successfully ✅")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Failed ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: ListView(
              children: [

                const SizedBox(height: 20),

                const Icon(Icons.person_add, size: 80, color: Colors.blue),

                const SizedBox(height: 10),

                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                // USERNAME
                TextFormField(
                  controller: user,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter username" : null,
                  decoration: inputDecoration("Username"),
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextFormField(
                  controller: email,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter email";
                    if (!v.contains("@")) return "Invalid email";
                    return null;
                  },
                  decoration: inputDecoration("Email"),
                ),

                const SizedBox(height: 15),

                // PHONE
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter phone";
                    if (v.length < 10) return "Invalid phone";
                    return null;
                  },
                  decoration: inputDecoration("Phone"),
                ),

                const SizedBox(height: 15),

                // PASSWORD
                TextFormField(
                  controller: pass,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter password";
                    if (v.length < 6) return "Min 6 characters";
                    return null;
                  },
                  decoration: inputDecoration("Password"),
                ),

                const SizedBox(height: 15),

                // ROLE
                DropdownButtonFormField(
                  value: role,
                  decoration: inputDecoration("Select Role"),
                  items: const [
                    DropdownMenuItem(value: "STUDENT", child: Text("Student")),
                    DropdownMenuItem(value: "ADMIN", child: Text("Admin")),
                    DropdownMenuItem(value: "LAB_ASSISTANT", child: Text("Lab Assistant")),
                  ],
                  onChanged: (val) => setState(() => role = val!),
                ),

                const SizedBox(height: 25),

                // BUTTON
                ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register"),
                ),

                const SizedBox(height: 10),

                // BACK TO LOGIN
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have account? Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}