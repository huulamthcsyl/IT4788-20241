import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import '../models/class_model.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';

class ClassRepository {
  final _authService = AuthService();

  Future<List<ClassInfo>> getOpenClasses() async {
    // Lấy UserData từ AuthService
    final userData = await _authService.getUserData();

    if (userData == null || userData.token.isEmpty) {
      throw GlobalException("Token không hợp lệ. Vui lòng đăng nhập lại.");
    }

    final httpUrl = Uri.http(BASE_API_URL, '/it4788/get_open_classes');
    final response = await http.post(
      httpUrl,
      headers: {
        'Authorization': 'Bearer ${userData.token}', // Sử dụng token từ UserData
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "pageable_request": {"page": "0", "page_size": "159"}
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == "1000") {
        // Parse danh sách lớp học
        final classes = body['data']['classes'] as List;
        return classes.map((e) => ClassInfo.fromJson(e)).toList();
      } else {
        throw GlobalException(body['message']);
      }
    } else {
      throw GlobalException("Lỗi kết nối máy chủ");
    }
  }
}

  /*Future<ClassInfo> getClassInfo(String classCode) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_class_info', {'class_code': classCode});
    final response = await http.get(httpUrl);

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == 1000) {
        return ClassInfo.fromJson(body['data']);
      } else {
        throw Exception(body['message']);
      }
    } else {
      throw Exception("Không thể lấy thông tin lớp học.");
    }
  }*/

  Future<void> registerClass(String classCode) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/register_class');
    final response = await http.post(
      httpUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'class_code': classCode}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == 1000) {
        print("Đăng ký lớp học thành công!");
      } else {
        throw Exception(body['message']);
      }
    } else {
      throw Exception("Không thể đăng ký lớp học.");
    }
  }

}
