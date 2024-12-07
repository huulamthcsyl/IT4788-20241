import 'package:flutter/material.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';

class NotificationDetailViewModel extends ChangeNotifier {

  final _notificationServices = NotificationServices();

  Future<void> markAsRead(int notificationId) async {
    await _notificationServices.markAsRead(notificationId.toString());
  }
}