import 'dart:convert';

SubmissionData submissionDataFromJson(String str) {
  return SubmissionData.fromJson(json.decode(str));
}

class StudentAccount {
  String accountId;
  String lastName;
  String firstName;
  String email;
  String studentId;

  StudentAccount({
    required this.accountId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.studentId,
  });

  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    return StudentAccount(
      accountId: json['account_id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      studentId: json['student_id'],
    );
  }
}

class SubmissionData {
  int id;
  int assignmentId;
  double? grade;
  String? fileUrl;
  String textResponse;
  String submissionTime;
  StudentAccount? studentAccount;

  SubmissionData({
    this.id = 0,
    this.assignmentId = 0,
    this.grade,
    this.fileUrl,
    this.textResponse = '',
    this.submissionTime = '',
    this.studentAccount,
  });

  factory SubmissionData.fromJson(Map<String, dynamic> json) {
    return SubmissionData(
      id: json['id'],
      assignmentId: json['assignment_id'],
      grade: json['grade'],
      fileUrl: json['file_url'],
      textResponse: json['text_response'],
      submissionTime: json['submission_time'],
      studentAccount: json['student_account'] != null
          ? StudentAccount.fromJson(json['student_account'])
          : null,
    );
  }
}