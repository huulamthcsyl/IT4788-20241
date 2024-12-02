import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/types/notification_type.dart';
import 'package:it4788_20241/utils/format_datetime.dart';

class NotificationDetailView extends StatelessWidget {
  final NotificationData notificationData;
  final UserData? senderInfo;

  const NotificationDetailView({super.key, required this.notificationData, required this.senderInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông báo ${notificationTypeLabel[notificationData.type] ?? ""}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              senderInfo?.name ?? "",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            Text(
              'Ngày gửi: ${formatDatetime(notificationData.sentTime.toUtc())}',
              style: const TextStyle(
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              notificationData.message,
              style: const TextStyle(
                fontSize: 20
              ),
            )
          ],
        ),
      ),
    );
  }
}
