import 'package:flutter/material.dart';
import '../../../services/ToolkitService.dart';

class DashboardTab extends StatefulWidget {
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {

  int kits = 0;
  int requests = 0;
  int pending = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final k = await ToolkitService.getAllKits();
    final r = await ToolkitService.getAllRequests();

    setState(() {
      kits = k.length;
      requests = r.length;
      pending = r.where((e) => e["status"] == "PENDING").length;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // 🔥 HEADER
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Admin Dashboard",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 STATS CARDS
          Row(
            children: [
              buildCard("Total Kits", kits, Colors.blue, Icons.inventory),
              const SizedBox(width: 10),
              buildCard("Requests", requests, Colors.green, Icons.list),
            ],
          ),

          const SizedBox(height: 10),

          buildFullCard("Pending Requests", pending, Colors.orange, Icons.pending),

          const SizedBox(height: 20),

          // 🔥 BAR GRAPH (CUSTOM)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 10),

          buildBarChart(),

          const SizedBox(height: 20),

          // 🔥 PIE STYLE (VISUAL)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Request Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 10),

          buildProgressChart(),
        ],
      ),
    );
  }

  // ================= CARDS =================

  Widget buildCard(String title, int value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              Text(title),
              const SizedBox(height: 5),
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

  Widget buildFullCard(String title, int value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  // ================= BAR CHART =================

  Widget buildBarChart() {
    double max = [kits, requests, pending].reduce((a, b) => a > b ? a : b).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        bar("Kits", kits, max, Colors.blue),
        bar("Requests", requests, max, Colors.green),
        bar("Pending", pending, max, Colors.orange),
      ],
    );
  }

  Widget bar(String label, int value, double max, Color color) {
    double height = (value / max) * 150;

    return Column(
      children: [
        Container(
          height: height,
          width: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  // ================= PROGRESS (PIE STYLE) =================

  Widget buildProgressChart() {
    double total = requests == 0 ? 1 : requests.toDouble();
    double pendingPercent = pending / total;

    return Column(
      children: [

        LinearProgressIndicator(
          value: pendingPercent,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: Colors.orange,
        ),

        const SizedBox(height: 10),

        Text("Pending: ${(pendingPercent * 100).toStringAsFixed(1)}%"),
      ],
    );
  }
}