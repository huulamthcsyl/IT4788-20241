import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/services/assignment_service.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssignmentDetailViewModel extends ChangeNotifier {
  final assignmentService = AssignmentService();
  final notificationService = NotificationServices();
  AssignmentData assignment;
  SubmissionData submission;
  final ClassData classData;
  final TextEditingController textController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late UserData userData;
  List<PlatformFile> selectedFiles = [];
  List<SubmissionData> responseList = [];
  List<SubmissionData> filteredResponseList = [];
  String searchQuery = '';
  double? grade = 0;
  bool _isDisposed = false;

  AssignmentDetailViewModel(this.assignment, this.submission, this.classData) {
    initialize();
  }

  Future<void> initialize() async {
    userData = await getUserData();
    responseList = await fetchAssignmentResponse();
    filteredResponseList = responseList;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filteredResponseList = responseList.where((response) {
      final fullName = '${response.studentAccount?.firstName} ${response.studentAccount?.lastName}'.toLowerCase();
      return fullName.contains(searchQuery.toLowerCase());
    }).toList();
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void showNotification(String msg, bool isError) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: isError == true ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  void updateText(String text) {
    textController.text = text;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void updateSelectedFiles(List<PlatformFile> files) {
    selectedFiles = files;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void removeSelectedFile(PlatformFile file) {
    selectedFiles.remove(file);
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void updateGrade(double? newGrade) {
    grade = newGrade;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> submitAssignment() async {
    try {
      String submissionId = await assignmentService.submitAssignment(
        userData.token,
        assignment.id,
        textController.text,
        selectedFiles,
      );

      assignment.isSubmitted = true;
      submission = await fetchSubmission();
      if (!_isDisposed) {
        notifyListeners();
      }
      showNotification('Nộp bài thành công', false);
    } catch (e) {
      showNotification('Nộp bài thất bại', true);
    }
  }

  Future<SubmissionData> fetchSubmission() async {
    if (!assignment.isSubmitted) {
      return SubmissionData();
    }
    SubmissionData submission = await assignmentService.fetchSubmission(
      userData.token,
      assignment.id,
    );
    return submission;
  }

  Future<List<SubmissionData>> fetchAssignmentResponse() async {
    return await assignmentService.fetchAssignmentResponse(userData.token, assignment.id, null, null);
  }

  Future<void> returnGrade(SubmissionData submission, String accountId) async {
    if (grade == null) {
      throw Exception('Vui lòng nhập điểm hợp lệ');
    }
    try {
      await assignmentService.fetchAssignmentResponse(userData.token, assignment.id, grade, submission.id);
      String message = 'Bài tập ${assignment.title}, lớp ${classData.className} đã được trả điểm.';
      await notificationService.sendNotification(message, accountId, null, 'ASSIGNMENT_GRADE');
      showNotification('Trả điểm thành công', false);
    } catch (e) {
      showNotification('Trả điểm thất bại', true);
    }
  }
}