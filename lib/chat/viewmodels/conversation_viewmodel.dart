import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/services/chat_service.dart';

class ConversationViewModel extends ChangeNotifier {
  int currentChatIndex = 0;
  final chatPageSize = 5;
  String conversationId = '';

  final _chatService = ChatService();

  final pagingController = PagingController<int, MessageData>(
    firstPageKey: 0,
  );

  ConversationViewModel() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(conversationId, pageKey);
    });
  }

  Future<void> fetchPage(String conversationId, int pageKey) async {
    try {
      final newItems = await _chatService.getConversation(conversationId, pageKey, chatPageSize);
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

  Future<void> refresh() async {
    pagingController.refresh();
  }

  void setConversationId(String id) {
    if (conversationId != id) {
      conversationId = id;
      pagingController.itemList = [];
      pagingController.itemList = null;
      pagingController.refresh();
    }
  }
}