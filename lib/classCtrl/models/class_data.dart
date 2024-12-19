class ClassData {
  String classId;
  String classCode; // Optional field for attached code
  String className;
  String? startDate;
  String? endDate;
  int maxStudents;
  String classType;
  String status;
  List<Student> studentAccounts; // List of students

  // Constructor
  ClassData({
    required this.classId,
    required this.classCode,
    required this.className,
    this.startDate,
    this.endDate,
    required this.maxStudents,
    required this.classType,
    required this.status,
    required this.studentAccounts, // Initialize the list of students
  });

  // Convert ClassData to JSON
  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'attached_code': classCode,
      'class_name': className,
      'start_date': startDate,
      'end_date': endDate,
      'student_count': maxStudents.toString(),
      'class_type': classType,
      'status': status,
      'student_accounts': studentAccounts.map((student) => student.toJson()).toList(),
    };
  }

  // Create ClassData from JSON
  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      classId: json['class_id'] ?? '',
      classCode: json['attached_code'] ?? '',
      className: json['class_name'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      maxStudents: int.tryParse(json['student_count'] ?? '0') ?? 0,
      classType: json['class_type'] ?? '',
      status: json['status'] ?? '',
      studentAccounts: (json['student_accounts'] as List<dynamic>? ?? [])
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
    );
  }
}

class Student {
  String accountId;
  String lastName;
  String firstName;
  String email;
  String studentId;

  Student({
    required this.accountId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.studentId,
  });

  // Convert Student to JSON
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'last_name': lastName,
      'first_name': firstName,
      'email': email,
      'student_id': studentId,
    };
  }

  // Create Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      accountId: json['account_id'] ?? '',
      lastName: json['last_name'] ?? '',
      firstName: json['first_name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['student_id'] ?? '',
    );
  }
}
