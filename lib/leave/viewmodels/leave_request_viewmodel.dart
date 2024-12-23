import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it4788_20241/leave/repositories/leave_request_repository.dart';
import 'dart:io';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';
import '../../classCtrl/models/class_data.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';
import 'package:it4788_20241/class/repositories/class_repository.dart';
import 'package:it4788_20241/utils/show_notification.dart';

class LeaveRequestViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final reasonController = TextEditingController();
  final dateController = TextEditingController();
  XFile? proofImage;

  final LeaveRequestRepository _repository = LeaveRequestRepository();
  final _notificationServices = NotificationServices();
  final ClassRepository _classRepository = ClassRepository();

  LeaveRequestViewModel() {
    initUserData();
  }
  ClassData classData = ClassData(classId: '', classCode: '', className: '', maxStudents: 0, classType: '', status: '', studentAccounts: []);

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
      showNotification("Điền đầy đủ thông tin", Colors.yellow);
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
        showNotification("Gửi đơn xin nghỉ thành công", Colors.green);
        print("Absence Request ID: ${response['data']['absence_request_id']}");
        // Gọi hàm gửi thông báo sau khi gửi yêu cầu thành công
        await notifyLecturer(classId, title, File(proofImage!.path));
      } else {
        print("Lỗi từ server: ${response['meta']['message']}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Hàm xử lý gửi thông báo
  Future<void> notifyLecturer(String classId, String title, File? proofImage) async {
    try {
      final classInfo = await _classRepository.getBasicClassInfo(userData.token, classId, userData.id);
      if (classInfo != null) {
        final lecturerId = classInfo.lecturer_account_id; // Lấy thông tin giảng viên
        await _notificationServices.sendNotification(
          title, // Tiêu đề là nội dung thông báo
          lecturerId,
          proofImage,
          "ABSENCE", // Loại thông báo
        );
        print("Gửi thông báo thành công đến giảng viên $lecturerId");
      } else {
        print("Không thể lấy thông tin lớp học.");
      }
    } catch (e) {
      print("Lỗi khi gửi thông báo: $e");
    }
  }

}
