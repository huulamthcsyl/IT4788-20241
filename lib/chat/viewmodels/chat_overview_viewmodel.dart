import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/services/chat_service.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/search/models/search_result_model.dart';
import 'package:it4788_20241/search/services/search_service.dart';

class ChatOverviewViewModel extends ChangeNotifier {
  int currentChatIndex = 0;
  final chatPageSize = 5;

  final _chatService = ChatService();
  final _searchService = SearchService();

  final _layoutViewModel = LayoutViewModel();

  final pagingController = PagingController<int, ConversationData>(
    firstPageKey: 0,
  );

  ChatOverviewViewModel() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await _chatService.getListConversation(pageKey, chatPageSize);
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
    _layoutViewModel.getUnreadMessageCount();
    pagingController.refresh();
  }

  Future<List<SearchResult>> getSearchResult(String searchContent) {
    return _searchService.getSearchResult(searchContent, "0", "5");
  }
}