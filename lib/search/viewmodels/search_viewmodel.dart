import 'package:flutter/material.dart';
import '../models/search_result_model.dart';
import '../services/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  final _searchService = SearchService();
  late List<SearchResult> _listSearchResult;
  Future<void> getSearchResults(String searchContent, int page, int pageSize) async {
    _listSearchResult = await _searchService.getSearchResult(searchContent, page.toString(), pageSize.toString());
    notifyListeners();
  }

  List<SearchResult> getSearchResult() {
    return _listSearchResult;
  }
}
