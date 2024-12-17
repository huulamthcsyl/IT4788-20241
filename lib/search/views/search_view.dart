import 'dart:async';
import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/views/search_profile_view.dart';
import 'package:it4788_20241/search/viewmodels/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);
return Scaffold(
appBar: AppBar(backgroundColor: Colors.red, automaticallyImplyLeading: false, title: Center(child: Text("TÌM KIẾM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
body: Column(
  children: [
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: viewModel.searchController,
          decoration: InputDecoration(hintText: "Nhập từ khóa tìm kiếm",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
          ),
        ),
        SizedBox(height: 10),
        if (viewModel.searchResults.isNotEmpty)Text("Kết quả tìm kiếm: ${viewModel.searchResults.length}", style: TextStyle(fontWeight: FontWeight.bold)),
        if (viewModel.searchResults.isEmpty && viewModel.searchController.text.isNotEmpty && !viewModel.isLoading)Text("Không có kết quả!", style: TextStyle(color: Colors.grey))
      ],
    ),
  ),
  Expanded(child: viewModel.isLoading ?
  Center(child: CircularProgressIndicator(color: Colors.red))
  : ListView.builder(controller: viewModel.scrollController, itemCount: viewModel.searchResults.length + (viewModel.isLoadingMore ? 1 : 0),
  itemBuilder: (context, index)
  {
    if (index == viewModel.searchResults.length) return Center(child: CircularProgressIndicator(color: Colors.red));
    final result = viewModel.searchResults[index];
    return GestureDetector(
    onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSearchProfilePage(accountId: result.account_id)))},
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${result.first_name} ${result.last_name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 5),
            Text(result.email, style: TextStyle(fontSize: 14, color: Colors.grey[700],),),
  ]))));})),
  if (viewModel.isLoadingMore)
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator(color: Colors.red)),
  )]));
  }
}