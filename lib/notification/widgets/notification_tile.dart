import 'package:flutter/material.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/types/notification_type.dart';
import 'package:it4788_20241/utils/time_from_now.dart';

class NotificationTile extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationTile({
    super.key,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        notificationTypeLabel[notificationData.type] ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notificationData.message),
          Text(
            fromNow(notificationData.sentTime),
            style: TextStyle(
              fontSize: 12,
              color: notificationData.status == "UNREAD"
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ],
      ),
      tileColor: notificationData.status == "UNREAD" ? Colors.grey[200] : null,
    );
  }
}
