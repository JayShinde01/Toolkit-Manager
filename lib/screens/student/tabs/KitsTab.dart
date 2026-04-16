import 'package:flutter/material.dart';
import '../../../services/ToolkitService.dart';

class KitsTab extends StatefulWidget {
  @override
  State<KitsTab> createState() => _KitsTabState();
}

class _KitsTabState extends State<KitsTab> {

  List kits = [];
  bool isLoading = true;
  int? loadingKitId; // 🔥 track which button is loading

  @override
  void initState() {
    super.initState();
    loadKits();
  }

  void loadKits() async {
    final data = await ToolkitService.getAllKits();

    setState(() {
      kits = data.where((k) =>
          k["status"] == "ACTIVE" &&
          k["availableQuantity"] > 0).toList();
      isLoading = false;
    });
  }

  // 🔥 REAL API CALL
  void requestKit(int kitId) async {
    setState(() => loadingKitId = kitId);

    bool success = await ToolkitService.requestToolkit(kitId);

    setState(() => loadingKitId = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Request sent successfully ✅"
              : "Request failed ❌",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kits.isEmpty) {
      return const Center(child: Text("No kits available"));
    }

    return ListView.builder(
      itemCount: kits.length,
      itemBuilder: (context, index) {
        final kit = kits[index];

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

                // 🔥 KIT NAME
                Text(
                  kit["name"],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                // 🔥 TYPE
                Text("Type: ${kit["type"]}"),

                // 🔥 DESCRIPTION
                Text(
                  kit["description"] ?? "",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                // 🔥 AVAILABILITY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available: ${kit["availableQuantity"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    // 🔥 REQUEST BUTTON
                    ElevatedButton(
                      onPressed: loadingKitId == kit["id"]
                          ? null
                          : () => requestKit(kit["id"]),
                      child: loadingKitId == kit["id"]
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          : const Text("Request"),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}