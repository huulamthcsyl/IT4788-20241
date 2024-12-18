import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/models/sender_data.dart';
import 'package:it4788_20241/chat/models/socket_message.dart';
import 'package:it4788_20241/chat/services/chat_service.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ConversationViewModel extends ChangeNotifier {
  int currentChatIndex = 0;
  final chatPageSize = 5;
  final messageTextController = TextEditingController();
  int partnerId = 0;
  PartnerData partnerData = PartnerData(
    id: 0,
    name: "",
    avatar: "",
  );

  final _chatService = ChatService();
  final _authService = AuthService();
  late StompClient client;

  final pagingController = PagingController<int, MessageData>(
    firstPageKey: 0,
  );

  ConversationViewModel() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(partnerId.toString(), pageKey);
    });
    _initSocket();
    client.activate();
  }

  Future<void> fetchPage(String partnerId, int pageKey) async {
    if (partnerId == "0") return;
    try {
      final newItems = await _chatService.getConversationByPartnerId(
          partnerId, pageKey, chatPageSize);
      final isLastPage = newItems.length < chatPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    client.deactivate();
    super.dispose();
  }

  Future<void> refresh() async {
    pagingController.refresh();
  }

  void setConversationInfo(int newPartnerId) async {
    if (partnerId != newPartnerId) {
      partnerId = newPartnerId;
      pagingController.itemList = [];
      pagingController.itemList = null;
      pagingController.refresh();
    }
    final partnerInfo = await _authService.getUserInfo(newPartnerId.toString());
    partnerData = PartnerData(
      id: int.parse(partnerInfo.id),
      name: partnerInfo.name,
      avatar: partnerInfo.avatar,
    );
    notifyListeners();
  }

  void _initSocket() {
    client = StompClient(
        config: StompConfig.sockJS(
      url: BASE_SOCKET_URL,
      onConnect: _onConnect,
    ));
  }

  void _onConnect(StompFrame frame) async {
    final userId = (await getUserData()).id;
    client.subscribe(
      destination: '/user/$userId/inbox',
      callback: (StompFrame frame) {
        if (frame.body == null) return;
        final message = SocketMessage.fromJson(jsonDecode(frame.body!));
        if (message.sender.id == partnerId || message.receiver.id == partnerId) {
          if (pagingController.itemList != null) {
            final list = List<MessageData>.from(pagingController.itemList!);
            list.insert(
                0,
                MessageData(
                    messageId: message.id.toString(),
                    sender: message.sender,
                    message: message.content,
                    createdAt: message.createdAt,
                    unread: 0));
            pagingController.itemList = list;
          }
        }
      },
    );
  }

  void sendMessage() async {
    final message = messageTextController.text;
    if (message.isNotEmpty) {
      final userData = await getUserData();
      client.send(
        destination: '/chat/message',
        body: jsonEncode({
          'receiver': {
            'id': partnerId,
          },
          'content': message,
          'sender': userData.email,
          'token': userData.token
        }),
      );
      messageTextController.clear();
    }
  }
}
