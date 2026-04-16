import 'package:flutter/material.dart';
import 'core/storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_home.dart';
import 'screens/admin/admin_home.dart';
import 'screens/lab/lab_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getStartScreen() async {
    String? role = await StorageService.getRole();

    if (role == "STUDENT") return StudentHome();
    if (role == "ADMIN") return AdminHome();
    if (role == "LAB_ASSISTANT") return LabHome();

    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _getStartScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}