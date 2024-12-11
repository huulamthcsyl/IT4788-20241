import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it4788_20241/leave/repositories/leave_request_repository.dart';
import 'dart:io';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';

class LeaveRequestViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final reasonController = TextEditingController();
  final dateController = TextEditingController();
  XFile? proofImage;

  final LeaveRequestRepository _repository = LeaveRequestRepository();

  LeaveRequestViewModel() {
    initUserData();
  }

  UserData userData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    status: '',
    role: '',
    avatar: '',
  );

  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }

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

    if (title.isEmpty || reason.isEmpty || date.isEmpty || proofImage == null) {
      // Hiển thị thông báo lỗi nếu có trường nào còn trống
      print("Yêu cầu chưa đầy đủ");
      return;
    }

    try {
      final response = await _repository.submitRequest(
        token: userData.token!,
        classId: classId,
        title: title,
        reason: reason,
        date: date,
        proofImage: File(proofImage!.path),
      );

      if (response['meta']['code'] == "1000") {
        print("Yêu cầu nghỉ phép thành công");
        print("Absence Request ID: ${response['data']['absence_request_id']}");
      } else {
        print("Lỗi từ server: ${response['meta']['message']}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
