import 'package:flutter/material.dart';
import '../../../services/ToolkitService.dart';

class HistoryTab extends StatefulWidget {
  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {

  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    setState(() => isLoading = true);

    final data = await ToolkitService.getMyRequests();

    setState(() {
      requests = data;
      isLoading = false;
    });
  }

  // 🔥 DELETE REQUEST
  void deleteRequest(int issueId) async {
    bool success = await ToolkitService.deleteRequest(issueId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deleted successfully ✅")),
      );
      loadRequests(); // refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete failed ❌")),
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return const Center(child: Text("No requests found"));
    }

    return RefreshIndicator(
      onRefresh: loadRequests,
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 KIT NAME (if nested)
                  Text(
                    req["toolkit"]?["name"] ?? "Toolkit",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  // 🔥 STATUS BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(req["status"]).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      req["status"],
                      style: TextStyle(
                        color: getStatusColor(req["status"]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 ACTION BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Issue ID: ${req["id"]}"),

                      if (req["status"] == "PENDING")
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteRequest(req["id"]),
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}