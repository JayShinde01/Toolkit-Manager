import 'package:flutter/material.dart';
import '../../../core/storage_service.dart';
import '../../../services/ToolkitService.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  String userName = "";
  int totalKits = 0;
  int myRequests = 0;
  int pendingRequests = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  void loadDashboard() async {
    final name = await StorageService.getUserName();
    final kits = await ToolkitService.getAllKits();
    final requests = await ToolkitService.getMyRequests();

    setState(() {
      userName = name ?? "User";
      totalKits = kits.length;
      myRequests = requests.length;
      pendingRequests =
          requests.where((r) => r["status"] == "PENDING").length;

      isLoading = false;
    });
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

          // 👋 HEADER
          Text(
            "Welcome, $userName 👋",
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 📊 STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCard("Total Kits", totalKits, Colors.blue),
              buildCard("My Requests", myRequests, Colors.green),
            ],
          ),

          const SizedBox(height: 10),

          buildCard("Pending Requests", pendingRequests, Colors.orange),

          const SizedBox(height: 20),

          // ⚡ QUICK ACTIONS
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(Icons.build),
            label: const Text("Request Toolkit"),
            onPressed: () {
              // switch to kits tab
              DefaultTabController.of(context);
            },
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(Icons.history),
            label: const Text("View History"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, int value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}