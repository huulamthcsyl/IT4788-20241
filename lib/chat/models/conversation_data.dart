import 'dart:convert';

import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/models/sender_data.dart';

ConversationData conversationDataFromJson(String str) =>
    ConversationData.fromJson(json.decode(str));

String conversationDataToJson(ConversationData data) =>
    json.encode(data.toJson());

class ConversationData {
  int id;
  PartnerData partner;
  MessageData lastMessage;
  DateTime createdAt;
  DateTime updatedAt;

  ConversationData({
    required this.id,
    required this.partner,
    required this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) =>
      ConversationData(
        id: json["id"],
        partner: PartnerData.fromJson(json["partner"]),
        lastMessage: MessageData.fromJson(json["last_message"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner": partner.toJson(),
        "last_message": lastMessage.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
