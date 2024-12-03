import 'dart:convert';

import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/models/notification_request.dart';

class NotificationRepository {
  Future<int> getUnreadNotificationCount(String token) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_unread_notification_count');
    final response = await http.post(httpUrl, body: jsonEncode(token), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        return body["data"];
      } else {
        throw GlobalException(body["meta"]["message"]);
      }
    } else {
      throw GlobalException('Không thể lấy số lượng thông báo mới');
    }
  }

  Future<List<NotificationData>> getNotifications(NotificationRequest notificationRequest) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_notifications');
    final response = await http.post(httpUrl, body: jsonEncode(notificationRequest), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        final notifications = body["data"].map<NotificationData>((item) => NotificationData.fromJson(item)).toList();
        return notifications;
      } else {
        throw GlobalException(body["meta"]["message"]);
      }
    } else {
      throw GlobalException('Không thể lấy thông báo');
    }
  }
}
