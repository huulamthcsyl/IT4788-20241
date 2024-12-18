import 'package:flutter/material.dart';
import 'package:it4788_20241/leave/models/leave_request_model.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import 'package:it4788_20241/leave/repositories/leave_request_repository.dart';
import '../../auth/models/user_data.dart';

class LeaveRequestListViewModel extends ChangeNotifier {
  final LeaveRequestRepository _repository = LeaveRequestRepository();
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

  // Hàm gọi API review_absence_request
  Future<void> reviewAbsenceRequest(String requestId, String status) async {
    try {
      await _repository.reviewAbsenceRequest(userData.token, requestId, status);
    } catch (e) {
      print("Error reviewing absence request: $e");
    }
  }

}
