import 'package:flutter/material.dart';
import '../../../services/student_service.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  final formKey = GlobalKey<FormState>();

  final user = TextEditingController();
  final pass = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final branch = TextEditingController();
  final division = TextEditingController();
  final prn = TextEditingController();
  final year = TextEditingController();

  bool isLoading = true;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final data = await StudentService.getProfile();

    if (data != null) {
      user.text = data["userName"] ?? "";
      email.text = data["email"] ?? "";
      phone.text = data["phone"] ?? "";
      branch.text = data["branch"] ?? "";
      division.text = data["division"] ?? "";
      prn.text = data["prn"] ?? "";
      year.text = data["year"]?.toString() ?? "";
    }

    setState(() => isLoading = false);
  }

  void updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    bool success = await StudentService.updateProfile({
      "userName": user.text,
      "password": pass.text,
      "email": email.text,
      "phone": phone.text,
      "branch": branch.text,
      "division": division.text,
      "prn": prn.text,
      "year": int.tryParse(year.text) ?? 1,
    });

    setState(() {
      isLoading = false;
      isEdit = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Updated ✅" : "Failed ❌")),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 🔥 PROFILE HEADER
          Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 10),
              Text(user.text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(email.text),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => setState(() => isEdit = !isEdit),
                child: Text(isEdit ? "Cancel" : "Edit Profile"),
              )
            ],
          ),

          const SizedBox(height: 20),

          // 🔥 FORM CARD
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    buildField(user, "Username"),
                    buildField(email, "Email"),
                    buildField(phone, "Phone"),
                    buildField(pass, "Password", isPassword: true),

                    const Divider(),

                    buildField(branch, "Branch"),
                    buildField(division, "Division"),
                    buildField(prn, "PRN"),
                    buildField(year, "Year"),

                    const SizedBox(height: 20),

                    if (isEdit)
                      ElevatedButton(
                        onPressed: updateProfile,
                        child: const Text("Save Changes"),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        enabled: isEdit, // 🔥 disable when not editing
        validator: (value) =>
            value == null || value.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEdit ? Colors.white : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}