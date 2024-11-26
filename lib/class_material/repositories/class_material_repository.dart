import 'dart:convert';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';

import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';

class MaterialRepository {

  final UserData _userData = getUserData() as UserData;
  Future<List<ClassMaterial>> getClassMaterial(String classCode) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_material_list');
    final Map<String, dynamic> body = {
      "token": _userData.token,
      "class_id": classCode,
    };
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['code'] == "1000") {
          List<dynamic> data = responseData['data'];
          return data.map((item) => ClassMaterial.fromJson(item)).toList();
        } else {
          print('Error: ${responseData['message']}');
          return [];
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Failed to load materials: $e');
      return [];
    }
  }
}