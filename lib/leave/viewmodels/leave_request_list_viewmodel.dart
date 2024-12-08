import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/leave/models/leave_request_model.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class LeaveRequestListViewModel extends ChangeNotifier {
  late List<LeaveRequest> _leaves = [];
  List<LeaveRequest> _leavereqs = [];
  String classcode = '';

  Future<void> fetchLeaveRequests() async {
    try {
      _leavereqs = await getLeaveRequests(classcode);
      print(_leavereqs);
      notifyListeners();
    } catch (e) {
      print("Error fetching leave requests: $e");
    }
  }

  // Hàm lấy danh sách đơn xin nghỉ từ API
  Future<List<LeaveRequest>> getLeaveRequests(String classCode) async {
    final userData = await getUserData();
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/get_absence_requests');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Authorization': 'Bearer ${userData.token}', // Sử dụng Bearer nếu cần
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData.token,
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
      print("Error: $e");
      return [];
    }
  }

  // Hàm lọc dữ liệu theo ngày
  List<LeaveRequest> getDisplayedLeaveRequests(String date) {
    return _leavereqs.where((leave) {
      return leave.absenceDate == date; // So sánh ngày nghỉ với ngày được chọn
    }).toList();
  }

  Future<void> showLeaveRequestDetails(BuildContext context, LeaveRequest item) async {
    bool isActionTaken = false;

    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Center(
                        child: Text(
                          'Chi tiết đơn xin nghỉ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      Divider(thickness: 1, height: 20),
                      // Thông tin sinh viên
                      Row( children: [
                      Text(
                        'Sinh viên: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${item.studentAccount.firstName} ${item.studentAccount.lastName}'), ],),
                      SizedBox(height: 8),
                Row( children: [
                      Text(
                        'MSSV: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.studentAccount.studentId), ],),
                      SizedBox(height: 8),
                Row( children: [
                      Text(
                        'Email: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.studentAccount.email), ],),
                      Divider(thickness: 1, height: 20),
                      // Thông tin đơn nghỉ
                Row( children: [
                      Text(
                        'Tiêu đề: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.title), ],),
                      SizedBox(height: 8),
                Row( children: [
                      Text(
                        'Lý do: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.reason), ],),
                      SizedBox(height: 8),
                Row( children: [
                      Text(
                        'Ngày: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.absenceDate), ],),
                      SizedBox(height: 8),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trạng thái: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.status,
                            style: TextStyle(
                              color: item.status == "PENDING"
                                  ? Colors.orange
                                  : item.status == "ACCEPTED"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Nút hành động
                      if (!isActionTaken && item.status == "PENDING") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () async {
                                await _reviewAbsenceRequest(item.id, "ACCEPTED");
                                setState(() {
                                  isActionTaken = true;
                                });
                                fetchLeaveRequests();
                              },
                              child: Text('Đồng ý', style: TextStyle(fontSize: 14)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () async {
                                await _reviewAbsenceRequest(item.id, "REJECTED");
                                setState(() {
                                  isActionTaken = true;
                                });
                                fetchLeaveRequests();
                              },
                              child: Text('Từ chối', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                      if (isActionTaken)
                        Center(
                          child: Text(
                            'Đã cập nhật trạng thái!',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      // Nút đóng
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: Text(
                            'Đóng',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print("Error in dialog: $e");
    }
  }


// Hàm gọi API review_absence_request
  Future<void> _reviewAbsenceRequest(String requestId, String status) async {
    final userData = await getUserData();
    final httpUrl = Uri.http(BASE_API_URL, '/it5023e/review_absence_request');
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          'Authorization': 'Bearer ${userData.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": userData.token,
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
