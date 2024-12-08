import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import '../models/class_model.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class ClassRepository {

  Future<List<ClassInfo>> getOpenClasses() async {
    final userData = await getUserData();

    if (userData != null && userData.token.isNotEmpty) {
      final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_open_classes');
      try {
        final response = await http.post(
          httpUrl,
          headers: {
            'Authorization': 'Bearer ${userData.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "token": userData.token,
            "pageable_request": {"page": "0", "page_size": "159"}
          }),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final body = jsonDecode(utf8.decode(response.bodyBytes));
          if (body['meta']['code'] == "1000") {
            final classes = (body['data']['page_content'] as List)
                .map((classJson) => ClassInfo.fromJson(classJson))
                .toList();
            return classes;
          } else {
            throw Exception("Error: ${body['meta']['message']}");
          }
        } else {
          throw Exception("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Error occurred: $e");
        rethrow;
      }
    } else {
      throw Exception("User not logged in. Please authenticate.");
    }
  }

  Future<ClassInfo?> getBasicClassInfo(String classId) async {
    final userData = await getUserData();

    if (userData != null && userData.token.isNotEmpty) {
      final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_basic_class_info');
      try {
        final response = await http.post(
          httpUrl,
          headers: {
            'Authorization': 'Bearer ${userData.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "token": userData.token,
            "role" : "STUDENT",
            "account_id" : userData.id,
            "class_id": classId,
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(utf8.decode(response.bodyBytes));
          if (body['meta']['code'] == "1000") {
            return ClassInfo.fromJson(body['data']);
          } else {
            throw Exception("Error: ${body['meta']['message']}");
          }
        } else {
          throw Exception("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Error occurred: $e");
        rethrow;
      }
    } else {
      throw Exception("User not logged in. Please authenticate.");
    }
  }

  Future<bool> registerClasses(List<String> classIds) async {
    final userData = await getUserData();

    if (userData != null && userData.token.isNotEmpty) {
      final httpUrl = Uri.http(BASE_API_URL, '/it5023e/register_class');
      try {
        final response = await http.post(
          httpUrl,
          headers: {
            'Authorization': 'Bearer ${userData.token}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "token": userData.token,
            "class_ids": classIds,
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          if (body['meta']['code'] == "1000") {
            return true;
          } else {
            throw Exception("Error: ${body['meta']['message']}");
          }
        } else {
          throw Exception("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Error occurred: $e");
        rethrow;
      }
    } else {
      throw Exception("User not logged in. Please authenticate.");
    }
  }

  Future<List<ClassInfo>> getClassList() async {
    final userData = await getUserData();

    if (userData != null && userData.token.isNotEmpty) {
      final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_class_list');
      try {
        final response = await http.post(
          httpUrl,
          headers: {
            'Authorization': 'Bearer ${userData.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "token": userData.token,
            "role": "STUDENT",
            "account_id": userData.id, // Lấy account ID từ userData
            "pageable_request": {"page": "0", "page_size": "159"}
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(utf8.decode(response.bodyBytes));
          if (body['meta']['code'] == "1000") {
            final classes = (body['data']['page_content'] as List).map((classJson) => ClassInfo.fromJson(classJson)).toList();
            return classes;
          } else {
            throw Exception("Error: ${body['meta']['message']}");
          }
        } else {
          throw Exception("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Error occurred while fetching class list: $e");
        rethrow;
      }
    } else {
      throw Exception("User not logged in. Please authenticate.");
    }
  }

}
