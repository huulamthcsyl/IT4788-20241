import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/services/chat_service.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/search/models/search_result_model.dart';
import 'package:it4788_20241/search/services/search_service.dart';

class ChatOverviewViewModel extends ChangeNotifier {

  final _chatService = ChatService();
  final _searchService = SearchService();

  final _layoutViewModel = LayoutViewModel();
  final listConversation = <ConversationData>[];

  void initPagingController() {
    fetchListConversation();
    _layoutViewModel.getUnreadMessageCount();
  }

  void fetchListConversation() async {
    final newItems = await _chatService.getListConversation(0, 100);
    listConversation.clear();
    listConversation.addAll(newItems);
    notifyListeners();
  }

  Future<void> refresh() async {
    initPagingController();
  }

  String convertGoogleDriveLink(String link) {
    final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/view');
    final match = regex.firstMatch(link);
    if (match != null && match.groupCount >= 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return link;
  }

  Future<List<SearchResult>> getSearchResult(String searchContent) {
    return _searchService.getSearchResult(searchContent, "0", "5");
  }
}