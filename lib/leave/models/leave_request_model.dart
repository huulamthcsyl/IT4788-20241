class LeaveRequest {
  String id;
  StudentAccount studentAccount;
  String absenceDate;
  String title;
  String reason;
  String status;

  LeaveRequest({
    required this.id,
    required this.studentAccount,
    required this.absenceDate,
    required this.title,
    required this.reason,
    required this.status,
  });

  // Factory constructor để tạo LeaveRequest từ JSON
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] ?? '',
      studentAccount: StudentAccount.fromJson(json['student_account'] ?? {}),
      absenceDate: json['absence_date'] ?? '',
      title: json['title'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Chuyển LeaveRequest sang JSON (tuỳ chọn, phục vụ gửi dữ liệu API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_account': studentAccount.toJson(),
      'absence_date': absenceDate,
      'title': title,
      'reason': reason,
      'status': status,
    };
  }
}

class StudentAccount {
  String accountId;
  String lastName;
  String firstName;
  String email;
  String studentId;

  StudentAccount({
    required this.accountId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.studentId,
  });

  // Factory constructor để tạo StudentAccount từ JSON
  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    return StudentAccount(
      accountId: json['account_id'] ?? '',
      lastName: json['last_name'] ?? '',
      firstName: json['first_name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['student_id'] ?? '',
    );
  }

  // Chuyển StudentAccount sang JSON
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'last_name': lastName,
      'first_name': firstName,
      'email': email,
      'student_id': studentId,
    };
  }
}
