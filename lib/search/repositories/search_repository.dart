import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../const/api.dart';
import '../models/search_result_model.dart';

class SearchRepository {
  Future<List<SearchResult>> getSearchResults(
      String searchContent, String page, String pageSize) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/search_account');
    final Map<String, dynamic> requestBody = {
      "search": searchContent,
      "pageable_request": {
        "page": page,
        "page_size": pageSize,
      },
    };

    try {
      final response = await http.post(
        httpUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(responseBody);

        if (responseData['meta']['code'] == "1000") {
          final List<dynamic> pageContent = responseData['data']['page_content'];
          return pageContent.map((json)
          {
            return SearchResult.fromJson(json);
          }).toList();
        } else {
          print('Error: ${responseData['meta']['message']}');
          return [];
        }
      } else {
        print('Error: HTTP ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Failed to load search results: $e');
      return [];
    }
  }
}
