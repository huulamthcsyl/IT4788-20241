import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import 'package:mime/mime.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/show_notification.dart';

class MaterialRepository {

  Future<List<ClassMaterial>> getClassMaterial(String? token, String classCode) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_material_list');
    final response = await http.post(
      httpUrl,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        "token": token,
        "class_id": classCode,
      }),
    );

    if (response.statusCode == 200) {
      // Decode response body using utf8.decode()
      final String responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseData = jsonDecode(responseBody);

      if (responseData['code'] == "1000") {
        List<dynamic> data = responseData['data'];
        return data.map((item) => ClassMaterial.fromJson(item)).toList();
      } else {
        print('Error: ${responseData['message']}');
        return [];
      }
    } else {
      print('Error: ${token} ${classCode}');
      return [];
    }
  }
  Future<void> deleteMaterial({required String? token, required String material_id}) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/delete_material');
    final Map<String, dynamic> body = {
      "token": token,
      "material_id": material_id,
    };
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      showNotification("Xóa tài liệu thất bại", Colors.red.withOpacity(0.9));
    }
  }

  Future<void> uploadFile({
    required String? token,
    required String classId,
    required String title,
    required String description,
    required String materialType,
    required File file,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/upload_material');
    var request = http.MultipartRequest('POST', httpUrl);
    request.files.add(http.MultipartFile(
        'file',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        filename: file.path.split("/").last));
    request.fields['token'] = token!;
    request.fields['classId'] = classId;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['materialType'] = materialType.split('.')[1];
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        showNotification("Upload thành công", Colors.green.withOpacity(0.9));
      } else {
        showNotification("Upload thất bại", Colors.red.withOpacity(0.9));
      }
    } catch (e) {
      showNotification("Upload thất bại", Colors.red.withOpacity(0.9));
    }
  }

  Future<void> editFile({
    required String? token,
    required String materialId,
    required String title,
    required String description,
    required String materialType,
    required File file,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/edit_material');
    var request = http.MultipartRequest('POST', httpUrl);
    request.files.add(http.MultipartFile(
        'file',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        filename: file.path
            .split("/")
            .last));

    request.fields['token'] = token!;
    request.fields['materialId'] = materialId;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['materialType'] = materialType.split('.')[1];
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        showNotification("Lưu thành công!", Colors.green.withOpacity(0.9));
      } else {
        showNotification("Lưu thất bại [1]", Colors.red.withOpacity(0.9));
      }
    } catch (e) {
      showNotification("Lưu thất bại [2]", Colors.red.withOpacity(0.9));
    }
  }
}