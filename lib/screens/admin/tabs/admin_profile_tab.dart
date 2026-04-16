import 'package:flutter/material.dart';
import '../../../services/admin_service.dart';

class AdminProfileTab extends StatefulWidget {
  @override
  State<AdminProfileTab> createState() => _AdminProfileTabState();
}

class _AdminProfileTabState extends State<AdminProfileTab> {

  final user = TextEditingController();
  final pass = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final dept = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // ================= LOAD PROFILE =================
  void loadProfile() async {
    final data = await AdminService.getProfile();

    if (data != null) {
      user.text = data["userName"] ?? "";
      email.text = data["email"] ?? "";
      phone.text = data["phone"] ?? "";
      dept.text = data["department"] ?? "";
    }

    setState(() => isLoading = false);
  }

  // ================= UPDATE PROFILE =================
  void update() async {
    setState(() => isSaving = true);

    Map<String, dynamic> body = {
      "userName": user.text,
      "email": email.text,
      "phone": phone.text,
      "department": dept.text,
    };

    // 🔥 Only send password if entered
    if (pass.text.isNotEmpty) {
      body["password"] = pass.text;
    }

    bool success = await AdminService.updateProfile(body);

    setState(() {
      isSaving = false;
      isEdit = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Updated Successfully ✅" : "Update Failed ❌"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [

          // ================= HEADER =================
          Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.admin_panel_settings, size: 40),
              ),
              const SizedBox(height: 10),

              Text(
                user.text,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Text(email.text),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => setState(() => isEdit = !isEdit),
                child: Text(isEdit ? "Cancel" : "Edit Profile"),
              )
            ],
          ),

          const SizedBox(height: 20),

          // ================= FORM =================
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  buildField(user, "Username"),
                  buildField(email, "Email"),
                  buildField(phone, "Phone"),
                  buildField(pass, "Password", isPassword: true),
                  buildField(dept, "Department"),

                  const SizedBox(height: 20),

                  if (isEdit)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : update,
                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Save Changes"),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget buildField(TextEditingController c, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: isPassword,
        enabled: isEdit,
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