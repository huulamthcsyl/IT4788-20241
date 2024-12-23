import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:it4788_20241/class_assignment/views/assignment_list_view.dart';
import 'package:it4788_20241/class_assignment/services/assignment_service.dart';
import 'package:it4788_20241/class_material/views/class_material_view.dart';
import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it4788_20241/utils/show_notifacation.dart';

class AssignmentAndSubmission {
  final AssignmentData assignment;
  final SubmissionData submission;
  final int? turnInCount;
  final int? gradeCount;

  AssignmentAndSubmission({
    required this.assignment,
    required this.submission,
    this.turnInCount,
    this.gradeCount,
  });
}

class AssignmentListViewModel extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final assignmentService = AssignmentService();
  late UserData userData;
  late List<AssignmentData> uAssignmentList = [];
  late List<AssignmentData> pAssignmentList = [];
  late List<AssignmentData> cAssignmentList = [];
  late List<AssignmentData> assignmentList = [];
  late List<SubmissionData> submissionList = [];
  late List<Object> responseList = [];
  Map<int, Map<String, int>> assignmentStats = {}; // Map to store turnInCount and gradeCount

  ClassData classData = ClassData(
    classId: '',
    classCode: '',
    className: '',
    maxStudents: 0,
    classType: '',
    status: '',
    studentAccounts: [],
  );
  String searchQuery = '';
  String selectedStatus = 'UPCOMING';

  AssignmentListViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    userData = await getUserData();
    if (userData.role == 'STUDENT') {
      uAssignmentList = await fetchAssignmentList('UPCOMING');
      pAssignmentList = await fetchAssignmentList('PASS_DUE');
      cAssignmentList = await fetchAssignmentList('COMPLETED');
      assign();
      await fetchSubmissionList();
    } else {
      assignmentList = await fetchAllAssignment();
      for (var assignment in assignmentList) {
        List<SubmissionData> responseList = await fetchAssignmentResponse(assignment);
        int turnInCount = responseList.length;
        int gradeCount = 0;
        for (var response in responseList) {
          if (response.grade != null) {
            gradeCount++;
          }
        }
        assignmentStats[assignment.id] = {'turnInCount': turnInCount, 'gradeCount': gradeCount};
      }
    }

    notifyListeners();
  }

  void assign() {
    switch (selectedStatus) {
      case 'UPCOMING':
        assignmentList = uAssignmentList;
        break;
      case ('PASS_DUE'):
        assignmentList = pAssignmentList;
        break;
      case ('COMPLETED'):
        assignmentList = cAssignmentList;
        break;
    }
  }

  Future<List<AssignmentData>> fetchAssignmentList(String status) async {
    return await assignmentService.fetchAssignmentListWithType(
      userData.token,
      status,
      classData.classId,
    );
  }

  Future<List<AssignmentData>> fetchAllAssignment() async {
    return await assignmentService.fetchAllAssignment(
      userData.token,
      classData.classId,
    );
  }

  Future<void> fetchSubmissionList() async {
    List<SubmissionData> submissions = [];

    for (var assignment in cAssignmentList) {
      try {
        SubmissionData submission = await fetchSubmission(assignment);
        submissions.add(submission);
      } catch (e) {
        submissions.add(SubmissionData());
      }
    }

    submissionList = submissions;
    notifyListeners();
  }

  Future<SubmissionData> fetchSubmission(AssignmentData assignment) async {
    if (!assignment.isSubmitted) {
      return SubmissionData();
    }
    SubmissionData submission = await assignmentService.fetchSubmission(
      userData.token,
      assignment.id,
    );
    return submission;
  }

  Future<List<SubmissionData>> fetchAssignmentResponse(AssignmentData assignment) async {
    return await assignmentService.fetchAssignmentResponse(userData.token, assignment.id, null, null);
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateSelectedStatus(String status) async {
    selectedStatus = status;
    assign();
    notifyListeners();
  }

  List<AssignmentAndSubmission> get filteredData {
    final filteredAssignments = assignmentList.where((assignment) {
      return assignment.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    filteredAssignments.sort((a, b) => a.deadline.compareTo(b.deadline)); // Sort by deadline

    return filteredAssignments.map((assignment) {
      if (selectedStatus != 'COMPLETED') {
        if (userData.role == 'LECTURER') {
          final stats = assignmentStats[assignment.id] ?? {'turnInCount': 0, 'gradeCount': 0};
          return AssignmentAndSubmission(
            assignment: assignment,
            submission: SubmissionData(),
            turnInCount: stats['turnInCount'],
            gradeCount: stats['gradeCount'],
          );
        }
        return AssignmentAndSubmission(
          assignment: assignment,
          submission: SubmissionData(),
        );
      }

      final submission = submissionList.firstWhere(
            (submission) => submission.assignmentId == assignment.id,
        orElse: () => SubmissionData(),
      );
      return AssignmentAndSubmission(
        assignment: assignment,
        submission: submission,
      );
    }).toList();
  }

  Future<void> deleteAssignment(int assignmentId) async {
    try {
      await assignmentService.deleteAssignment(userData.token, assignmentId);
      showNotification('Xóa bài tập thành công', false);
    } catch (e) {
      showNotification('Xóa bài tập thất bại', true);
    } finally {
      notifyListeners();

    }

  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void onClickTabBar(int index, BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = AssignmentListView(classData: classData);
        break;
      case 1:
        page = ClassMaterialPage(classData: classData);
        break;
      case 2:
        page = ClassFunctionPage(classData: classData);
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}