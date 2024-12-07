import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/auth/models/user_data.dart'; // Import lớp UserData
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/const/api.dart';

class ApiService {
  final String baseUrl = BASE_API_URL;
  final UserData userData;  // Added UserData as a dependency

  // Constructor to initialize userData
  ApiService({required this.userData});

  // Fetch class list
  Future<List<dynamic>> getClassList({
    required int page,
    required int pageSize,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_class_list');
    final response = await http.post(
      httpUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "token": userData.token,  // Use token from UserData
        "role": userData.role,    // Use role from UserData
        "account_id": userData.id,  // Use account_id from UserData
        "pageable_request": {
          "page": page.toString(),
          "page_size": pageSize.toString(),
        }
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

      if (resData['meta']['code'] == '1000') {
        List<dynamic> classList = resData['data']['page_content'] ?? [];
        return classList;
      } else {
        throw Exception('Error: ${resData['meta']['message']}');
      }
    } else {
      throw Exception('Failed to fetch class list. Status code: ${response.statusCode}');
    }
  }

  // Fetch class info
  Future<List<dynamic>> getClassInfo({
    required int page,
    required int pageSize,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_class_info');
    final response = await http.post(
      httpUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "token": userData.token,  // Use token from UserData
        "role": userData.role,    // Use role from UserData
        "account_id": userData.id,  // Use account_id from UserData
        "pageable_request": {
          "page": page.toString(),
          "page_size": pageSize.toString(),
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> resData = jsonDecode(utf8.decode(response.bodyBytes));

      if (resData['meta']['code'] == '1000') {
        List<dynamic> classInfo = resData['data']['page_content'] ?? [];
        return classInfo;
      } else {
        throw Exception('Error: ${resData['meta']['message']}');
      }
    } else {
      throw Exception('Failed to fetch class info. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> createClass(ClassData classData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/create_class');

    try {
      final Map<String, dynamic> requestBody = {
        "token": userData.token,  // Use token from UserData
        "class_id": classData.classId,
        "class_name": classData.className,  // Vietnamese supported
        "class_type": classData.classType, // LT, BT, LT_BT
        "start_date": classData.startDate,
        "end_date": classData.endDate,
        "max_student_amount": classData.maxStudents,
      };

      print(requestBody);

      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',  // Ensure UTF-8 encoding
          'Authorization': 'Bearer ${userData.token}',  // Use the token from UserData
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

  Future<bool> editClassDetails(ClassData classData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/edit_class');

    try {
      final Map<String, dynamic> requestBody = {
        "token": userData.token,  // Use token from UserData
        "role": userData.role,    // Use role from UserData
        "class_id": classData.classId,
        "class_name": classData.className,  // Vietnamese supported
        "start_date": classData.startDate,
        "end_date": classData.endDate,
      };

      print(requestBody);

      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userData.token}',  // Use the token from UserData
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

  Future<bool> deleteClass(String classId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/delete_class');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData.token,  // Use token from UserData
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

  // Update class status
  Future<bool> updateClassStatus(String classId, String status) async {
    final url = Uri.parse('$baseUrl/update_class_status');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "token": userData.token,  // Use token from UserData
        "role": userData.role,    // Use role from UserData
        "class_id": classId,
        "status": status,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update class status. Status code: ${response.statusCode}');
    }
  }
}
