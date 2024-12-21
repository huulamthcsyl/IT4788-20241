import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/services/assignment_service.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';

class CreateAssignmentViewModel extends ChangeNotifier {
  late UserData userData;
  final assignmentService = AssignmentService();
  final ClassData classData;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<PlatformFile> selectedFiles = [];
  DateTime? selectedDate;
  String? titleError;
  String? dateError;
  final AssignmentData? assignmentData;

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
    dateError = null;
    notifyListeners();
  }

  bool validateInputs() {
    bool isValid = true;
    if (titleController.text.isEmpty) {
      titleError = 'Tiêu đề không được để trống';
      isValid = false;
    }
    if (selectedDate == null) {
      dateError = 'Ngày đến hạn không được để trống';
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  void createAssignment() async {
    if (validateInputs()) {
      if (assignmentData == null) {
        await assignmentService.createAssignment(
          userData.token,
          classData.classId,
          descriptionController.text,
          titleController.text,
          selectedDate!,
          selectedFiles,
        );
      } else {
        await assignmentService.editAssignment(
          userData.token,
          assignmentData!.id,
          descriptionController.text,
          selectedDate!,
          selectedFiles,
        );
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