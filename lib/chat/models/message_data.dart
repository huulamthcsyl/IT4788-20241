import 'dart:convert';

import 'package:it4788_20241/chat/models/sender_data.dart';

MessageData messageDataFromJson(String str) =>
    MessageData.fromJson(json.decode(str));

String messageDataToJson(MessageData data) => json.encode(data.toJson());

class MessageData {
  String? messageId;
  String? message;
  PartnerData sender;
  DateTime createdAt;
  int unread;

  MessageData({
    this.messageId,
    required this.message,
    required this.sender,
    required this.createdAt,
    required this.unread,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        messageId: json["message_id"],
        message: json["message"],
        sender: PartnerData.fromJson(json["sender"]),
        createdAt: DateTime.parse(json["created_at"]),
        unread: json["unread"],
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "message": message,
        "sender": sender.toJson(),
        "created_at": createdAt.toIso8601String(),
        "unread": unread,
      };
}
