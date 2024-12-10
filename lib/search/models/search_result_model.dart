class SearchResult{
  String account_id;
  String last_name;
  String first_name;
  String email;
  String role;
  SearchResult({
    required this.account_id,
    required this.last_name,
    required this.first_name,
    required this.email,
    required this.role
  });
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      account_id: json['account_id']?.toString() ?? '', // Xử lý null
      last_name: json['last_name'] ?? '',              // Giá trị mặc định nếu null
      first_name: json['first_name'] ?? '',
      email: json['email'] ?? '',
      role: ''
    );
  }
}