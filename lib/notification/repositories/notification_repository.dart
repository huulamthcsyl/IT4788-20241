import 'dart:convert';
import 'dart:io';

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

  Future<void> markAsRead(String token, String notificationId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/mark_notification_as_read');
    final response = await http.post(httpUrl, body: jsonEncode({
      "token": token,
      "notification_id": notificationId
    }), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] != "1000") {
        throw GlobalException(body["meta"]["message"]);
      }
    } else {
      throw GlobalException('Không thể đánh dấu thông báo đã đọc');
    }
  }

  Future<void> sendNotification(String token, String message, String toUser, File? image, String type) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/send_notification');
    final request = http.MultipartRequest('POST', httpUrl)
      ..fields['token'] = token
      ..fields['message'] = message
      ..fields['toUser'] = toUser
      ..fields['type'] = type;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(await response.stream.first));
      if(body["meta"]["code"] != "1000") {
        throw GlobalException(body["meta"]["message"]);
      }
    } else {
      throw GlobalException('Không thể gửi thông báo');
    } 
  }
}
