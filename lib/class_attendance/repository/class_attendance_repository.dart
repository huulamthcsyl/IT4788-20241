import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/class_attendance/models/class_attendance_model.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:intl/intl.dart';

class ClassAttendanceRepository {
  Future<List<AttendanceData>> fetchAttendanceList(
      String? token, String classId, DateTime date, int count) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_attendance_list');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "pageable_request": {"page": 0, "page_size": count}
    };

    final response = await http.post(
      httpUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 400) {
      if (responseBody['data'] == "this date has no record") {
        return [];
      }
    }
    if (response.statusCode == 200) {
      if (responseBody['meta']['code'] == '1000') {
        List<dynamic> data = responseBody['data']['attendance_student_details'];
        return data.map((item) => AttendanceData.fromJson(item)).toList();
      }
    }

    throw GlobalException(responseBody['message']);
  }

  Future<void> takeAttendance(String? token, String classId, DateTime date,
      List<String> studentList) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/take_attendance');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "attendance_list": studentList
    };

    final response = await http.post(
      httpUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      if (responseBody['meta']['code'] == '1000') {
        String message = responseBody['data'];
        return;
      }
    }

    throw GlobalException(responseBody['message']);
  }

  Future<void> setAttendanceStatus(
      String? token, String status, String attendanceId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/set_attendance_status');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "status": status,
      "attendance_id": attendanceId,
    };

    final response = await http.post(
      httpUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      if (responseBody['meta']['code'] == '1000') {
        // List<dynamic> data = responseBody['data'];
        return;
      }
    }

    throw GlobalException(responseBody['message']);
  }
}
