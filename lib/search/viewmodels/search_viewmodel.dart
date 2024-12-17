import 'dart:async';
import 'package:flutter/material.dart';
import '../models/search_result_model.dart';
import '../services/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  final _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  Timer? _debounce;
  String _lastSearchText = "";
  final ScrollController _scrollController = ScrollController();

  SearchViewModel() {
    _searchController.addListener(_onSearchTextChanged);
    _scrollController.addListener(_onScroll);
  }

  List<SearchResult> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  TextEditingController get searchController => _searchController;
  ScrollController get scrollController => _scrollController;

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _searchResults.isNotEmpty) {
      _loadMoreResults();
    }
  }

  void _loadMoreResults() {
    _isLoadingMore = true;
    notifyListeners();
    _currentPage++;
    _performSearch();
  }

  void _onSearchTextChanged() {
    String currentText = _searchController.text.trim();
    if (currentText != _lastSearchText) {
      _searchResults = [];
      _isLoading = true;
      _isLoadingMore = false;
      _currentPage = 0;
      _lastSearchText = currentText;
      notifyListeners();

      _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 3), () {
        if (_searchController.text.trim().isNotEmpty) {
          _performSearch();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
      return;
    }
    _isLoading = _currentPage == 0;
    notifyListeners();
    final searchContent = _searchController.text.trim();
    await getSearchResults(searchContent, _currentPage, _pageSize);
  }

  Future<void> getSearchResults(
      String searchContent, int page, int pageSize) async {
    List<SearchResult> newResults = await _searchService.getSearchResult(
        searchContent, page.toString(), pageSize.toString());
    _searchResults.addAll(newResults);
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}