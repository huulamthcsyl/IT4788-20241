class ClassData {
  String classId;
  String classCode; // Giả sử điều này có thể được thiết lập sau hoặc không được sử dụng trong phản hồi API.
  String className;
  String? startDate;
  String? endDate;
  int maxStudents;
  String classType;
  String status;
  List<Student> studentAccounts; // Danh sách sinh viên

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
    required this.studentAccounts, // Khởi tạo danh sách sinh viên
  });

  // Chuyển đổi ClassData thành JSON
  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'attached_code': classCode,
      'class_name': className,
      'start_date': startDate,
      'end_date': endDate,
      'student_count': maxStudents.toString(), // Chuyển đổi lại thành chuỗi nếu cần
      'class_type': classType,
      'status': status,
      'student_accounts': studentAccounts.map((student) => student.toJson()).toList(), // Chuyển đổi danh sách sinh viên thành JSON
    };
  }

  // Tạo ClassData từ JSON
  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      classId: json['class_id'] ?? '',  // Mapping từ phản hồi API
      classCode: json['attached_code'] ?? '',  // Giả sử điều này là tùy chọn
      className: json['class_name'] ?? '',
      startDate: json['start_date'], // Có thể là null
      endDate: json['end_date'], // Có thể là null
      maxStudents: int.tryParse(json['student_count'] ?? '0') ?? 0,  // Chuyển đổi sang int
      classType: json['class_type'] ?? '',
      status: json['status'] ?? '',
      studentAccounts: (json['student_accounts'] as List<dynamic>? ?? [])
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(), // Mapping danh sách sinh viên thành lớp Student
    );
  }
}

class Student {
  String name;

  Student(this.name);

  Map<String, dynamic> toJson() => {'name': name};

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(json['name'] ?? '');  // Mặc định là chuỗi rỗng nếu tên là null
  }
}