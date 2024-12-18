import 'dart:convert';

import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/models/conversation_request.dart';
import 'package:it4788_20241/chat/models/list_conversation_request.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  Future<List<ConversationData>> getListConversation(ListConversationRequest request) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_list_conversation');
    final response = await http.post(httpUrl, body: jsonEncode(request), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        final conversations = body["data"]["conversations"].map<ConversationData>((item) => ConversationData.fromJson(item)).toList();
        return conversations;
      } else {
        throw Exception(body["meta"]["message"]);
      }
    } else {
      throw Exception('Không thể lấy danh sách cuộc trò chuyện');
    }
  }

  Future<List<MessageData>> getConversation(ConversationRequest request) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_conversation');
    final response = await http.post(httpUrl, body: jsonEncode(request), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        final messages = body["data"]["conversation"].map<MessageData>((item) => MessageData.fromJson(item)).toList();
        return messages;
      } else {
        throw Exception(body["meta"]["message"]);
      }
    } else {
      throw Exception('Không thể lấy cuộc trò chuyện');
    }
  }

  Future<int> getUnreadMessageCount(String token) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_list_conversation');
    final response = await http.post(httpUrl, body: jsonEncode({"token": token, "index": 0, "count": 1}), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        return int.parse(body["data"]["num_new_message"]);
      } else {
        throw Exception(body["meta"]["message"]);
      }
    } else {
      throw Exception('Không thể lấy số tin nhắn chưa đọc');
    }
  }

  Future<List<MessageData>> getConversationByPartnerId(String partnerId, String token, int index, int count) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_conversation');
    final response = await http.post(httpUrl, body: jsonEncode({
        "partner_id": partnerId, 
        "token": token,
        "index": index,
        "count": count
      }), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if(body["meta"]["code"] == "1000") {
        final messages = body["data"]["conversation"].map<MessageData>((item) => MessageData.fromJson(item)).toList();
        return messages;
      } else {
        throw Exception(body["meta"]["message"]);
      }
    } else {
      throw Exception('Không thể lấy cuộc trò chuyện');
    }
  }
}
