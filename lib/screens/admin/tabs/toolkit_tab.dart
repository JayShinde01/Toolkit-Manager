import 'package:flutter/material.dart';
import '../../../services/admin_service.dart';
import '../../../services/ToolkitService.dart';

class ToolkitTab extends StatefulWidget {
  @override
  State<ToolkitTab> createState() => _ToolkitTabState();
}

class _ToolkitTabState extends State<ToolkitTab> {

  List kits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await ToolkitService.getAllKits();
    setState(() {
      kits = data;
      isLoading = false;
    });
  }

  // ================= ADD TOOLKIT =================
  void showAddDialog() {
    showToolkitDialog();
  }

  // ================= UPDATE TOOLKIT =================
  void showUpdateDialog(Map kit) {
    showToolkitDialog(existing: kit);
  }

  // ================= COMMON FORM =================
  void showToolkitDialog({Map? existing}) {
    final name = TextEditingController(text: existing?["name"] ?? "");
    final type = TextEditingController(text: existing?["type"] ?? "");
    final desc = TextEditingController(text: existing?["description"] ?? "");
    final total = TextEditingController(
        text: existing?["totalQuantity"]?.toString() ?? "");
    final available = TextEditingController(
        text: existing?["availableQuantity"]?.toString() ?? "");
    final qr = TextEditingController(text: existing?["qrCode"] ?? "");

    String status = existing?["status"] ?? "ACTIVE";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? "Add Toolkit" : "Update Toolkit"),
        content: SingleChildScrollView(
          child: Column(
            children: [

              buildField(name, "Name"),
              buildField(type, "Type"),
              buildField(desc, "Description"),
              buildField(total, "Total Quantity"),
              buildField(available, "Available Quantity"),
              buildField(qr, "QR Code"),

              DropdownButtonFormField(
                value: status,
                items: const [
                  DropdownMenuItem(value: "ACTIVE", child: Text("Active")),
                  DropdownMenuItem(value: "INACTIVE", child: Text("Inactive")),
                ],
                onChanged: (v) => status = v!,
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ],
          ),
        ),
        actions: [

          TextButton(
            onPressed: () async {

              Map<String, dynamic> body = {
                "name": name.text,
                "type": type.text,
                "description": desc.text,
                "totalQuantity": int.tryParse(total.text) ?? 0,
                "availableQuantity": int.tryParse(available.text) ?? 0,
                "status": status,
                "qrCode": qr.text
              };

              if (existing == null) {
                await AdminService.addToolkit(body);
              } else {
                await AdminService.updateToolkit(existing["id"], body);
              }

              Navigator.pop(context);
              load();
            },
            child: Text(existing == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }

  Widget buildField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: kits.length,
        itemBuilder: (c, i) {
          final k = kits[i];

          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(

              title: Text(
                k["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Type: ${k["type"]}"),
                  Text("Available: ${k["availableQuantity"]}/${k["totalQuantity"]}"),
                  Text("Status: ${k["status"]}"),
                ],
              ),

              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => showUpdateDialog(k),
              ),
            ),
          );
        },
      ),
    );
  }
}