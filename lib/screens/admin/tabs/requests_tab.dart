import 'package:flutter/material.dart';
import '../../../services/ToolkitService.dart';
import '../../../services/admin_service.dart';

class RequestsTab extends StatefulWidget {
  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {

  List data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = await ToolkitService.getAllRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (c, i) {
        final r = data[i];

        return Card(
          child: ListTile(
            title: Text(r["toolkit"]?["name"] ?? ""),
            subtitle: Text(r["status"]),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                if (r["status"] == "PENDING")
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      await ToolkitService.approveRequest(r["id"]);
                      load();
                    },
                  ),

                if (r["status"] == "PENDING")
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      await AdminService.rejectRequest(r["id"]);
                      load();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}