import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import '../models/class_model.dart';

class ClassRepository {
  Future<List<ClassInfo>> getClassList() async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_class_list');
    final response = await http.get(httpUrl);

    if (response.statusCode == 200) {
      print('Kết nối thành công và nhận được dữ liệu!');
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == 1000) {
        return (body['data'] as List).map((e) => ClassInfo.fromJson(e)).toList();
      } else {
        throw Exception(body['message']);
      }
    } else {
      throw Exception("Không thể tải danh sách lớp học.");
    }
  }

  Future<ClassInfo> getClassInfo(String classCode) async {
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
  }

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
