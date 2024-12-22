import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");
  return formatter.format(dateTime);
}

class AssignmentRepository {
  Future<int> createAssignment(
      String? token,
      String classId,
      String description,
      String title,
      DateTime deadline,
      List<PlatformFile> files) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/create_survey');
    final request = http.MultipartRequest('POST', httpUrl)
      ..fields['token'] = token ?? ''
      ..fields['classId'] = classId
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['deadline'] = deadline.toIso8601String().split('.')[0];

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path!));
    }

    final response = await request.send();
    final responseString = await http.Response.fromStream(response);
    final Map<String, dynamic> jsonResponse = jsonDecode(responseString.body);

    if (response.statusCode == 200) {
      if (jsonResponse['meta']['code'] == '1000') {
        int assignmentId = jsonResponse['data'];
        return assignmentId;
      }
    }

    throw Exception(jsonResponse['meta']['message']);
  }

  Future<void> editAssignment(String? token, int assignmentId,
      String description, DateTime deadline, List<PlatformFile> files) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/edit_survey');
    final request = http.MultipartRequest('POST', httpUrl)
      ..fields['token'] = token ?? ''
      ..fields['assignmentId'] = assignmentId.toString()
      ..fields['description'] = description
      ..fields['deadline'] = deadline.toIso8601String().split('.')[0];
    // ..fields['deadline'] = '2025-12-26T14:30:00';

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path!));
    }

    final response = await request.send();
    final responseString = await http.Response.fromStream(response);
    final Map<String, dynamic> jsonResponse = jsonDecode(responseString.body);

    if (response.statusCode == 200) {
      if (jsonResponse['meta']['code'] == '1000') {
        // AssignmentData assignmentData = jsonResponse['data'];
        // return assignmentData;
        return;
      }
    }

    throw Exception(jsonResponse['meta']['message']);
  }

  Future<void> deleteAssignment(String? token, int assignmentId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/delete_survey');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "survey_id": assignmentId.toString(),
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
        // return data.map((item) => AssignmentData.fromJson(item)).toList();
      }
    }

    if (response.statusCode == 500) {
      throw GlobalException(
          'Không thể xóa bài tập đã có phản hồi của sinh viên.');
    }

    throw GlobalException(responseBody['message']);
  }

  Future<List<AssignmentData>> fetchAssignmentListWithType(
      String? token, String type, String classId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_student_assignments');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "type": type,
      "class_id": classId,
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
        List<dynamic> data = responseBody['data'];
        return data.map((item) => AssignmentData.fromJson(item)).toList();
      }
    }

    throw GlobalException(responseBody['message']);
  }

  Future<List<AssignmentData>> fetchAllAssignment(
      String? token, String classId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_all_surveys');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "class_id": classId,
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
        List<dynamic> data = responseBody['data'];
        return data.map((item) => AssignmentData.fromJson(item)).toList();
      }
    }

    throw GlobalException(responseBody['message']);
  }

  Future<List<SubmissionData>> fetchAssignmentResponse(
      String? token, int assignmentId, double? score, int? submissionId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_survey_response');
    Map<String, dynamic> requestBody = {
      "token": token,
      "survey_id": assignmentId.toString(),
    };
    if (score != null) {
      requestBody["grade"] = {"score": score, "submission_id": submissionId};
    }

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
        List<dynamic> data = responseBody['data'];
        return data.map((item) => SubmissionData.fromJson(item)).toList();
      }
    }

    throw GlobalException(responseBody['message']);
  }

  Future<String> submitAssignment(String? token, int assignmentId,
      String textResponse, List<PlatformFile> files) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/submit_survey');
    final request = http.MultipartRequest('POST', httpUrl)
      ..fields['token'] = token ?? ''
      ..fields['assignmentId'] = assignmentId.toString()
      ..fields['textResponse'] = textResponse;

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path!));
    }

    final response = await request.send();
    final responseString = await http.Response.fromStream(response);
    final Map<String, dynamic> jsonResponse = jsonDecode(responseString.body);
    print(jsonResponse);
    print(jsonResponse['meta']['message']);
    if (response.statusCode == 200) {
      if (jsonResponse['meta']['code'] == '1000') {
        String submissionId = jsonResponse['data']['submission_id'];
        return submissionId;
      }
    }

    throw Exception(jsonResponse['meta']['message']);
  }

  Future<SubmissionData> fetchSubmission(
      String? token, int assignmentId) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_submission');
    final Map<String, dynamic> requestBody = {
      "token": token,
      "assignment_id": assignmentId,
    };

    final response = await http.post(
      httpUrl,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      if (responseBody['meta']['code'] == '1000') {
        return SubmissionData.fromJson(responseBody['data']);
      }
    }

    throw GlobalException(responseBody['message']);
  }
}
