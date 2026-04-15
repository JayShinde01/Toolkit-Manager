import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toolkit_manager/features/auth/presentation/pages/register_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(), // ✅ THIS IS IMPORTANT
    );
  }
}