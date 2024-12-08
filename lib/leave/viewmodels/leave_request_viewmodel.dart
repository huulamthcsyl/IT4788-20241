import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class LeaveRequestViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final reasonController = TextEditingController();
  final dateController = TextEditingController();
  XFile? proofImage;

  // Hàm chọn ảnh từ thư mục
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    proofImage = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  // Xóa ảnh
  void removeImage() {
    proofImage = null;
    notifyListeners();
  }

// Xem ảnh
  void previewImage(BuildContext context) {
    if (proofImage != null) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Image.file(
            File(proofImage!.path),
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }


  // Hàm chọn ngày nghỉ phép
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      notifyListeners();
    }
  }

  // Hàm xử lý submit yêu cầu nghỉ phép
  Future<void> submitRequest(String classId) async {
    String title = titleController.text;
    String reason = reasonController.text;
    String date = dateController.text;
    final userData = await getUserData();

    if (title.isEmpty || reason.isEmpty || date.isEmpty || proofImage == null) {
      // Hiển thị thông báo lỗi nếu có trường nào còn trống
      print("Yêu cầu chưa đầy đủ");
      return;
    }

    try {
      // Chuyển đổi định dạng ngày từ dd-MM-yyyy sang yyyy-MM-dd
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // Tạo request multipart
      var uri = Uri.http(BASE_API_URL, '/it5023e/request_absence');
      var request = http.MultipartRequest('POST', uri)
        ..fields['token'] = userData.token
        ..fields['classId'] = classId
        ..fields['date'] = formattedDate
        ..fields['reason'] = reason
        ..fields['title'] = title;

      // Thêm file minh chứng
      if (proofImage != null) {
        var file = File(proofImage!.path);
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: proofImage!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Gửi request và nhận phản hồi
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        if (jsonResponse['meta']['code'] == "1000") {
          print("Yêu cầu nghỉ phép thành công");
          print("Absence Request ID: ${jsonResponse['data']['absence_request_id']}");
        } else {
          print("Lỗi từ server: ${jsonResponse['meta']['message']}");
        }
      } else {
        print("Lỗi kết nối: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi ngoại lệ: $e");
    }
  }

}
