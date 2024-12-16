import 'dart:async';
import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/views/search_profile_view.dart';
import 'package:it4788_20241/search/viewmodels/search_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/search_result_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<SearchResult> _searchResults;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  Timer? _debounce;
  String _lastSearchText = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchResults = [];
    _searchController.addListener(_onSearchTextChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll()
  {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
      _loadMoreResults();
  }

  void _loadMoreResults() {
    if (!_isLoadingMore && _searchResults.isNotEmpty)
    {
      setState(()
      {
        _isLoadingMore = true;
        _currentPage++;
      });
      _performSearch();
    }
  }

  void _onSearchTextChanged()
  {
    String currentText = _searchController.text.trim();
    if (currentText != _lastSearchText)
    {
      setState(() {
        _searchResults = [];
        _isLoading = true;
        _isLoadingMore = false;
        _currentPage = 0;
        _lastSearchText = currentText;
      });
      _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 3), ()
      {
        if (_searchController.text.trim().isNotEmpty)
          _performSearch();
        else
          setState(() {_isLoading = false;});

      });
    }
  }

  void _performSearch() async
  {
    if (_searchController.text.isEmpty)
    {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      return;
    }
    setState(() {_isLoading = _currentPage == 0;});
    final searchContent = _searchController.text.trim();
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    await viewModel.getSearchResults(searchContent, _currentPage, _pageSize);
    setState(() {
      _isLoading = false;
      _isLoadingMore = false;
      _searchResults.addAll(viewModel.getSearchResult());
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =  Provider.of<SearchViewModel>(context);
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: Center(
        child: Text(
        "TÌM KIẾM",
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    body: Column(
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    TextField(
    controller: _searchController,
    decoration: InputDecoration(
    hintText: "Nhập từ khóa tìm kiếm",
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    ),
      SizedBox(height: 10),
      if (_searchResults.isNotEmpty)
        Text(
          "Kết quả tìm kiếm: ${_searchResults.length}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      if (_searchResults.isEmpty && _searchController.text.isNotEmpty && !_isLoading)
        Text(
          "Không có kết quả!",
          style: TextStyle(color: Colors.grey),
        ),
    ],
    ),
    ),
      Expanded(
        child: _isLoading && _currentPage == 0
            ? Center(child: CircularProgressIndicator(color: Colors.red))
            : ListView.builder(
          controller: _scrollController,
          itemCount: _searchResults.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _searchResults.length) {
              return Center(child: CircularProgressIndicator(color: Colors.red));
            }
            final result = _searchResults[index];
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSearchProfilePage(
                      accountId: result.account_id,
                    ),
                  ),
                )
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${result.first_name} ${result.last_name}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        result.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      if (_isLoadingMore)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator(color: Colors.red)),
        ),
    ],
    ),
    );
  }
}