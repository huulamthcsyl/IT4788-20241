import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/services/assignment_service.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it4788_20241/utils/show_notification.dart';

class CreateAssignmentViewModel extends ChangeNotifier {
  late UserData userData;
  final assignmentService = AssignmentService();
  final ClassData classData;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<PlatformFile> selectedFiles = [];
  DateTime? selectedDate = DateTime.now(); // Set selectedDate to current date and time
  String? titleError;
  final AssignmentData? assignmentData;
  bool isLoading = false;

  CreateAssignmentViewModel(this.classData, this.assignmentData) {
    _initialize();
    if (assignmentData != null) {
      titleController.text = assignmentData!.title;
      descriptionController.text = assignmentData!.description;
      selectedDate = DateTime.parse(assignmentData!.deadline);
    }
  }

  void _initialize() async {
    userData = await getUserData();
  }

  void updateTitle(String text) {
    titleController.text = text;
    titleError = null;
    notifyListeners();
  }

  void updateDescription(String text) {
    descriptionController.text = text;
    notifyListeners();
  }

  void updateSelectedFiles(List<PlatformFile> files) {
    selectedFiles = files;
    notifyListeners();
  }

  void removeSelectedFile(PlatformFile file) {
    selectedFiles.remove(file);
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  bool validateInputs() {
    bool isValid = true;
    if (titleController.text.isEmpty) {
      showNotification('Tiêu đề không được để trống', Colors.yellow.withOpacity(0.9));
      isValid = false;
    }
    if (selectedDate == null) {
      showNotification('Ngày đến hạn không được để trống', Colors.yellow.withOpacity(0.9));
      isValid = false;
    } else if (selectedDate!.isBefore(DateTime.now())) {
      showNotification('Ngày đến hạn không được trước thời gian hiện tại', Colors.yellow.withOpacity(0.9));
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  Future<void> createAssignment(BuildContext context) async {
    if (validateInputs()) {
      isLoading = true;
      notifyListeners();
      try {
        if (assignmentData == null) {
          await assignmentService.createAssignment(
            userData.token,
            classData.classId,
            descriptionController.text,
            titleController.text,
            selectedDate!,
            selectedFiles,
          );
          showNotification('Tạo bài tập thành công', Colors.green.withOpacity(0.9));
        } else {
          await assignmentService.editAssignment(
            userData.token,
            assignmentData!.id,
            descriptionController.text,
            selectedDate!,
            selectedFiles,
          );
          showNotification('Cập nhật bài tập thành công', Colors.green.withOpacity(0.9));
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        showNotification('Đã xảy ra lỗi. $e', Colors.red.withOpacity(0.9));
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  String formatDate(DateTime dateTime) {
    try {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}