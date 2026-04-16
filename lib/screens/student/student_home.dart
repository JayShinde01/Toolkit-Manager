import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit_manager/screens/auth/login_screen.dart';
import 'package:toolkit_manager/screens/student/notifications_screen.dart';
import 'package:toolkit_manager/screens/student/tabs/HomeTab.dart';
import 'package:toolkit_manager/screens/student/tabs/KitsTab.dart';
import 'package:toolkit_manager/screens/student/tabs/ProfileTab.dart';
import 'package:toolkit_manager/screens/student/tabs/HistoryTab.dart';
import '../../../services/notification_service.dart';
import '../../../core/storage_service.dart';

class StudentHome extends StatefulWidget {
  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  int currentIndex = 0;
  int notificationCount = 0;

  String userName = "";
  String role = "";

  final List<Widget> screens = [
    HomeTab(),
    KitsTab(),
    HistoryTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    loadNotifications();
    loadUserData();
  }

  // 🔔 Load unread notifications count
  void loadNotifications() async {
    int count = await NotificationService.getUnreadCount();
    setState(() => notificationCount = count);
  }

  // 👤 Load user data from storage
  void loadUserData() async {
    final name = await StorageService.getUserName();
    final r = await StorageService.getRole();

    setState(() {
      userName = name ?? "User";
      role = r ?? "Role";
    });
  }

  // 🔓 Logout
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          children: [

            // 🔥 USER HEADER
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(role),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),

            // 🔹 NAV ITEMS
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.build),
              title: const Text("Kits"),
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            // 🔴 LOGOUT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        centerTitle: true,

        actions: [
          Stack(
            children: [

              // 🔔 ICON
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NotificationsScreen()),
                  );

                  loadNotifications(); // refresh badge
                },
              ),

              // 🔴 BADGE
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$notificationCount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),

      // ================= BODY =================
      body: screens[currentIndex],

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: "Kits"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}