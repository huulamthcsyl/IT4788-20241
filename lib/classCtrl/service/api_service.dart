import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/auth/models/user_data.dart'; // Import lớp UserData
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class ApiService {
  final String baseUrl = BASE_API_URL;

  // Biến toàn cục để lưu thông tin UserData
  UserData? userData;

  // Hàm để khởi tạo hoặc cập nhật UserData
  Future<void> initializeUserData() async {
    // if (userData == null) {
      userData = await getUserData();
    // }
  }

  // Hàm đảm bảo userData luôn được khởi tạo
  Future<void> _ensureUserDataInitialized() async {
    // if (userData == null) {
      await initializeUserData();  // Khởi tạo userData chỉ khi cần thiết
    // }
  }

  // Fetch class list
  Future<List<dynamic>> getClassList({
    required int page,
    required int pageSize,
  }) async {
    // Tách logic khởi tạo dữ liệu người dùng ra khỏi các API calls chính
    await _ensureUserDataInitialized();  // Chỉ gọi khi chưa khởi tạo userData

    final httpUrl = Uri.http(baseUrl, '/it5023e/get_class_list');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData!.token,  // Use token from UserData
          "role": userData!.role,    // Use role from UserData
          "account_id": userData!.id,  // Use account_id from UserData
          "pageable_request": {
            "page": page.toString(),
            "page_size": pageSize.toString(),
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

        if (resData['meta']['code'] == '1000') {
          return resData['data']['page_content'] ?? [];
        } else {
          throw Exception('Error: ${resData['meta']['message']}');
        }
      } else {
        throw Exception('Failed to fetch class list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching class list: $e');
    }
  }

  // Fetch class info
  Future<Map<String, dynamic>> getClassInfo({
    required String classId,
  }) async {
    await _ensureUserDataInitialized();
    final httpUrl = Uri.http(baseUrl, '/it5023e/get_class_info');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData!.token,  // Use token from UserData
          "role": userData!.role,    // Use role from UserData
          "account_id": userData!.id,  // Use account_id from UserData
          "class_id": classId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

        if (resData['meta']['code'] == '1000') {
          return resData['data'];
        } else {
          throw Exception('Error: ${resData['meta']['message']}');
        }
      } else {
        throw Exception('Failed to fetch class info. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching class info: $e');
    }
  }

  // Create class
  Future<Map<String, dynamic>?> createClass(ClassData classData) async {
    await _ensureUserDataInitialized();
    final httpUrl = Uri.http(baseUrl, '/it5023e/create_class');

    try {
      final Map<String, dynamic> requestBody = {
        "token": userData!.token,  // Use token from UserData
        "class_id": classData.classId,
        "class_name": classData.className,  // Vietnamese supported
        "class_type": classData.classType, // LT, BT, LT_BT
        "start_date": classData.startDate,
        "end_date": classData.endDate,
        "max_student_amount": classData.maxStudents,
      };

      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',  // Ensure UTF-8 encoding
          'Authorization': 'Bearer ${userData!.token}',  // Use the token from UserData
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

        if (resData['meta']['code'] == '1000') {
          return resData['data'];
        } else {
          throw Exception('Error: ${resData['meta']['message']}');
        }
      } else {
        throw Exception('Failed to create class. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling API: $e');
      return null;
    }
  }

  // Edit class details
  Future<bool> editClassDetails(ClassData classData) async {
    await _ensureUserDataInitialized();
    final httpUrl = Uri.http(baseUrl, '/it5023e/edit_class');

    try {
      final Map<String, dynamic> requestBody = {
        "token": userData!.token,  // Use token from UserData
        "role": userData!.role,    // Use role from UserData
        "class_id": classData.classId,
        "class_name": classData.className,  // Vietnamese supported
        "start_date": classData.startDate,
        "end_date": classData.endDate,
      };

      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userData!.token}',  // Use the token from UserData
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

        if (resData['meta']['code'] == '1000') {
          return true;
        } else {
          throw Exception('Error: ${resData['meta']['message']}');
        }
      } else {
        throw Exception('Failed to edit class. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error editing class: $e');
      return false;
    }
  }

  // Delete class
  Future<bool> deleteClass(String classId) async {
    await _ensureUserDataInitialized();
    final httpUrl = Uri.http(baseUrl, '/it5023e/delete_class');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData!.token,  // Use token from UserData
          "class_id": classId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));
        if (resData['meta']['code'] == '1000') {
          return true;
        } else {
          throw Exception('Error: ${resData['meta']['message']}');
        }
      } else {
        throw Exception('Failed to delete class. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting class: $e');
      return false;
    }
  }
}
