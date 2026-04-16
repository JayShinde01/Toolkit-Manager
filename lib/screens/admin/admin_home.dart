import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit_manager/screens/auth/login_screen.dart';
import 'package:toolkit_manager/screens/student/notifications_screen.dart';

import 'tabs/dashboard_tab.dart';
import 'tabs/requests_tab.dart';
import 'tabs/toolkit_tab.dart';
import 'tabs/admin_profile_tab.dart';

import '../../core/storage_service.dart';
import '../../services/notification_service.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  int index = 0;
  int notificationCount = 0;

  String userName = "";
  String role = "";

  final screens = [
    DashboardTab(),
    RequestsTab(),
    ToolkitTab(),
    AdminProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
    loadNotifications();
  }

  // ================= USER DATA =================
  void loadUser() async {
    final name = await StorageService.getUserName();
    final r = await StorageService.getRole();

    setState(() {
      userName = name ?? "Admin";
      role = r ?? "ADMIN";
    });
  }

  // ================= NOTIFICATIONS =================
  void loadNotifications() async {
    int count = await NotificationService.getUnreadCount();
    setState(() => notificationCount = count);
  }

  // ================= LOGOUT =================
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

            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(role),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings, size: 40),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                setState(() => index = 0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Requests"),
              onTap: () {
                setState(() => index = 1);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.build),
              title: const Text("Toolkits"),
              onTap: () {
                setState(() => index = 2);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                setState(() => index = 3);
                Navigator.pop(context);
              },
            ),

            const Divider(),

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
        title: const Text("Admin Panel"),
        centerTitle: true,

        actions: [
          Stack(
            children: [

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
      body: screens[index],

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Requests"),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: "Toolkits"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}