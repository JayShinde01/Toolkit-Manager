import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toolkit_manager/features/auth/presentation/pages/register_page.dart';
import 'package:toolkit_manager/features/auth/presentation/pages/login_page.dart';
// import 'package:toolkit_manager/features/home/admin_home.dart;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 IMPORTANT
      initialRoute: "/register",

      routes: {
        "/register": (context) => const RegisterPage(),
        "/login": (context) => const LoginPage(), // ✅ FIX HERE
          // "/studentHome": (context) => const StudentHome(),
          // "/adminHome": (context) => const AdminHome(),
          // "/labHome": (context) => const LabHome(),

      },
    );
  }
}