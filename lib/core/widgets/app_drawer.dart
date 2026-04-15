import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text("Toolkit Manager"),
          ),

          ListTile(
            title: const Text("Home"),
            onTap: () {},
          ),

          if (role == "ADMIN") ...[
            ListTile(
              title: const Text("Manage Users"),
              onTap: () {},
            ),
          ],

          if (role == "LAB_ASSISTANT") ...[
            ListTile(
              title: const Text("Approve Requests"),
              onTap: () {},
            ),
          ],

          ListTile(
            title: const Text("Logout"),
            onTap: () {
              // clear token and navigate
            },
          ),
        ],
      ),
    );
  }
}