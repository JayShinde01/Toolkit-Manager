import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  List notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    setState(() => isLoading = true);

    final data = await NotificationService.getNotifications();

    setState(() {
      notifications = data;
      isLoading = false;
    });
  }

  void markAsRead(int id) async {
    bool success = await NotificationService.markAsRead(id);

    if (success) {
      loadNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marked as read ✅")),
      );
    }
  }

  Color getColor(bool isRead) {
    return isRead ? Colors.grey : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("No notifications"))
              : RefreshIndicator(
                  onRefresh: loadNotifications,
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final n = notifications[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(

                          // 🔥 MESSAGE
                          title: Text(n["message"] ?? "Notification"),

                          // 🔥 STATUS
                          subtitle: Text(
                            n["read"] ? "Read" : "Unread",
                            style: TextStyle(
                              color: getColor(n["read"]),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // 🔥 ACTION
                          trailing: !n["read"]
                              ? IconButton(
                                  icon: const Icon(Icons.done, color: Colors.green),
                                  onPressed: () => markAsRead(n["id"]),
                                )
                              : const Icon(Icons.check, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}