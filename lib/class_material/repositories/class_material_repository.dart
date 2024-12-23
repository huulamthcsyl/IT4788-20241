import 'dart:convert';
import 'dart:io';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import 'package:mime/mime.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      print('Failed to delete material: $e');
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
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      throw Exception("Không xác định được MIME type của file");
    }
    var request = http.MultipartRequest('POST', httpUrl);
    request.files.add(
        http.MultipartFile(
            'file',
            File(file.path).readAsBytes().asStream(),
            File(file.path).lengthSync(),
            filename: file.path.split("/").last
        )
    );
    request.fields['token'] = token!;
    request.fields['classId'] = classId;
    request.fields['title'] = title;
    request.fields['description'] = description;
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    request.fields['materialType'] = materialType;
=======
    request.fields['materialType'] = materialType.split('.')[1];
>>>>>>> Stashed changes
=======
    request.fields['materialType'] = materialType.split('.')[1];
>>>>>>> Stashed changes

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        print("Upload thành công: $responseBody");
      } else {
        print("Upload thất bại: ${await response.stream.bytesToString()} ${classId} ${title} ${description} ${materialType.split('.')[1]}");
      }
    } catch (e) {
      print("Lỗi khi upload file: $e");
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
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      throw Exception("Không xác định được MIME type của file");
    }
    var request = http.MultipartRequest('POST', httpUrl);
    request.files.add(
        http.MultipartFile(
            'file',
            File(file.path).readAsBytes().asStream(),
            File(file.path).lengthSync(),
            filename: file.path.split("/").last
        )
    );
    request.fields['token'] = token!;
    request.fields['materialId'] = materialId;
    request.fields['title'] = title;
    request.fields['description'] = description;
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    request.fields['materialType'] = materialType;
=======
    request.fields['materialType'] = materialType.split('.')[1];
>>>>>>> Stashed changes
=======
    request.fields['materialType'] = materialType.split('.')[1];
>>>>>>> Stashed changes

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        print("Lưu thành công: $responseBody");
      } else {
<<<<<<< Updated upstream
        print("Lưu thất bại: ${await response.stream.bytesToString()} ${materialId} ${title} ${description} ${materialType}");
=======
        print("Lưu thất bại: ${await response.stream
            .bytesToString()} ${materialId} ${title} ${description} ${materialType.split('.')[1]}");
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
      }
    } catch (e) {
      print("Lỗi khi Lưu file: $e");
    }
  }
}