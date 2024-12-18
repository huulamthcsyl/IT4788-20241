import 'package:flutter/material.dart';
import 'package:it4788_20241/leave/models/leave_request_model.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:it4788_20241/leave/repositories/leave_request_repository.dart';
import '../../auth/models/user_data.dart';

class LeaveRequestListViewModel extends ChangeNotifier {
  final LeaveRequestRepository _repository = LeaveRequestRepository();
  late List<LeaveRequest> _leaves = [];
  List<LeaveRequest> _leavereqs = [];
  String classcode = '';

  UserData userData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    status: '',
    role: '',
    avatar: '',
  );

  LeaveRequestListViewModel() {
    _init();
  }

  void _init() async {
    await initUserData();
    if (userData.token != null) {
      await fetchLeaveRequests();
    }
  }

  Future<void> initUserData() async {
    try {
      userData = await getUserData();
      notifyListeners();
      print("userData.token: ${userData.token}");
    } catch (e) {
      print("Error initializing user data: $e");
    }
  }

  Future<void> fetchLeaveRequests() async {
    try {
      if (userData.token == null) {
        print("Token is empty. Cannot fetch leave requests.");
        return;
      }
      print("Fetching leave requests with token: ${userData.token}");
      _leavereqs = await _repository.getLeaveRequests(userData.token, classcode);
      notifyListeners();
    } catch (e) {
      print("Error fetching leave requests: $e");
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
    try {
      await _repository.reviewAbsenceRequest(userData.token, requestId, status);
    } catch (e) {
      print("Error reviewing absence request: $e");
    }
  }

}
