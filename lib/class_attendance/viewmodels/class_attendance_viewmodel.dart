import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/class_attendance/models/class_attendance_model.dart';
import 'package:it4788_20241/class_attendance/repository/class_attendance_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:it4788_20241/utils/show_notification.dart';

class ClassAttendanceViewModel extends ChangeNotifier {
  late ClassData classData;
  late UserData userData;
  final attendanceRepo = ClassAttendanceRepository();
  List<Map<String, String>> attendanceList = [];
  List<Map<String, String>> filteredAttendanceList = [];
  List<AttendanceData> attendanceData = [];
  String searchQuery = '';
  DateTime selectedDate = DateTime.now();

  ClassAttendanceViewModel() {
    _init();
  }

  void _init() async {
    userData = await getUserData();
    attendanceData = await attendanceRepo.fetchAttendanceList(
      userData.token,
      classData.classId,
      selectedDate,
      classData.maxStudents,
    );
    updateAttendance();
    notifyListeners();
  }

  void updateAttendance() {
    attendanceList = classData.studentAccounts.map((student) {
      final attendance = attendanceData.firstWhere(
        (data) => data.studentId == student.studentId,
      );
      return {
        'name': '${student.firstName} ${student.lastName}',
        'email': student.email,
        'status': attendance.status,
        'studentId': student.studentId,
      };
    }).toList();
    filteredAttendanceList = attendanceList;
    notifyListeners();
  }

  void setClassData(ClassData data) {
    classData = data;
    updateAttendance();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filteredAttendanceList = attendanceList.where((student) {
      return student['email']!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void updateAttendanceStatus(String email, String status) {
    for (var student in attendanceList) {
      if (student['email'] == email) {
        student['status'] = status;
        break;
      }
    }
    updateSearchQuery(searchQuery); // Refresh the filtered list
  }

  void updateSelectedDate(DateTime date) async {
    selectedDate = date;
    attendanceData = await attendanceRepo.fetchAttendanceList(
      userData.token,
      classData.classId,
      date,
      classData.maxStudents,
    );
    updateAttendance();
    notifyListeners();
  }

  void clearSearchAndResetAttendance() {
    searchQuery = '';
    attendanceList = classData.studentAccounts.map((student) {
      return {
        'name': '${student.firstName} ${student.lastName}',
        'email': student.email,
        'status': 'PRESENT',
      };
    }).toList();
    filteredAttendanceList = attendanceList;
    notifyListeners();
  }

  void saveAttendance() async {
    try {
      await takeAllAttendance();
      await setAttendanceStatus();
      showNotification('Điểm danh thành công', Colors.green.withOpacity(0.9));
    } catch (e) {
      showNotification('Điểm danh thất bại', Colors.red.withOpacity(0.9));
    } finally {
      notifyListeners();
    }
  }

  Future<void> takeAllAttendance() async {
    List<String> studentList = classData.studentAccounts.map((student) {
      return student.studentId;
    }).toList();

    await attendanceRepo.takeAttendance(
        userData.token, classData.classId, selectedDate, studentList);
    // Perform any additional operations with studentList if needed
  }

  Future<void> setAttendanceStatus() async {
    attendanceData = await attendanceRepo.fetchAttendanceList(
        userData.token, classData.classId, selectedDate, classData.maxStudents);

    for (var attendance in attendanceData) {
      for (var student in attendanceList) {
        if (attendance.studentId == student['studentId']) {
          await attendanceRepo.setAttendanceStatus(
              userData.token, student['status']!, attendance.attendanceId);
        }
      }
    }
  }
}
