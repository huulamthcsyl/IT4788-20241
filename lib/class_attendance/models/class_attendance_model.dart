import 'dart:convert';

AttendanceData attendanceDataFromJson(String str) =>
    AttendanceData.fromJson(json.decode(str));

class AttendanceData {
  String attendanceId;
  String studentId;
  String status;

  AttendanceData(
      {required this.attendanceId,
      required this.status,
      required this.studentId});

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
      attendanceId: json['attendance_id'],
      studentId: json['student_id'],
      status: json['status']);

  Map<String, dynamic> toJson() => {};
}
