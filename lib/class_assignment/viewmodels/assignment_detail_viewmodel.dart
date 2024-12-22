import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/services/assignment_service.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

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

  AssignmentDetailViewModel(this.assignment, this.submission, this.classData) {
    _initialize();
  }

  void _initialize() async {
    userData = await getUserData();
    responseList = await fetchAssignmentResponse();
    filteredResponseList = responseList;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filteredResponseList = responseList.where((response) {
      final fullName = '${response.studentAccount?.firstName} ${response.studentAccount?.lastName}'.toLowerCase();
      return fullName.contains(searchQuery.toLowerCase());
    }).toList();
    notifyListeners();
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

  void updateGrade(double? newGrade) {
    grade = newGrade;
    notifyListeners();
  }

  @override
  void dispose() {
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
      notifyListeners();
    } catch (e) {
      print('Error submitting assignment: $e');
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
    await assignmentService.fetchAssignmentResponse(userData.token, assignment.id, grade, submission.id);
    String message = 'Bài tập ${assignment.title}, lớp ${classData.className} đã được trả điểm.';
    await notificationService.sendNotification(message, accountId, null, 'ASSIGNMENT_GRADE');
  }
}