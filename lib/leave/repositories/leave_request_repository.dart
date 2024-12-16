import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/leave/models/leave_request_model.dart';

class LeaveRequestRepository {

  Future<Map<String, dynamic>> submitRequest({
    required String token,
    required String classId,
    required String title,
    required String reason,
    required String date,
    required File proofImage,
  }) async {
    try {
      // Chuyển đổi định dạng ngày từ dd-MM-yyyy sang yyyy-MM-dd
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // Tạo request multipart
      var uri = Uri.http(BASE_API_URL, '/it5023e/request_absence');
      var request = http.MultipartRequest('POST', uri)
        ..fields['token'] = token
        ..fields['classId'] = classId
        ..fields['date'] = formattedDate
        ..fields['reason'] = reason
        ..fields['title'] = title;

      // Thêm file minh chứng
      var stream = http.ByteStream(proofImage.openRead());
      var length = await proofImage.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: proofImage.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Gửi request và nhận phản hồi
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        return jsonResponse;
      } else {
        throw Exception("Lỗi kết nối: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi ngoại lệ: $e");
    }
  }

  // Lấy danh sách đơn xin nghỉ
  Future<List<LeaveRequest>> getLeaveRequests(String? token, String classCode) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_absence_requests');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Authorization': 'Bearer ${token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": token,
          "class_id": classCode,
          "status": null,
          "pageable_request": {"page": "0", "page_size": "100"}
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body['meta']['code'] == "1000") {
          return (body['data']['page_content'] as List)
              .map((item) => LeaveRequest.fromJson(item))
              .toList();
        } else {
          throw Exception("Error: ${body['meta']['message']}");
        }
      } else {
        throw Exception("Failed to load leave requests. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching leave requests: $e");
      return [];
    }
  }

  // Gửi review đơn nghỉ
  Future<void> reviewAbsenceRequest(String? token, String requestId, String status) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/review_absence_request');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Authorization': 'Bearer ${token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": token,
          "request_id": requestId,
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body['meta']['code'] == "1000") {
          print("Review successful: ${body['data']}");
        } else {
          throw Exception("Error: ${body['meta']['message']}");
        }
      } else {
        throw Exception("Failed to review absence request. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error reviewing absence request: $e");
    }
  }

}
