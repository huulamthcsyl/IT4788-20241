import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

  // Hàm chọn ngày nghỉ phép
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners();
    }
  }

  // Hàm xử lý submit yêu cầu nghỉ phép
  void submitRequest() {
    String title = titleController.text;
    String reason = reasonController.text;
    String date = dateController.text;
    if (title.isEmpty || reason.isEmpty || date.isEmpty || proofImage == null) {
      // Hiển thị thông báo lỗi nếu có trường nào còn trống
      print("Yêu cầu chưa đầy đủ");
    } else {
      // Xử lý yêu cầu nghỉ phép ở đây (gọi API hoặc lưu vào CSDL)
      print("Yêu cầu nghỉ phép đã được gửi");
    }
  }
}
