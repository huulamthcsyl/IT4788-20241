import 'package:it4788_20241/search/models/search_result_model.dart';
import 'package:it4788_20241/search/repositories/search_repository.dart';

class SearchService {
  final _searchRepository = SearchRepository();

  Future<List<SearchResult>> getSearchResult(String searchContent, String page,
      String page_size) async
  {
    return await _searchRepository.getSearchResults(searchContent, page, page_size);
  }
}