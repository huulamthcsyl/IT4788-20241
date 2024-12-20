class ClassInfo {
  String class_id;
  String class_name;
  String attached_code;
  String class_type;
  String lecturer_name;
  String lecturer_account_id;
  String student_count;
  String start_date;
  String end_date;
  String status;

  ClassInfo({
    required this.class_id,
    required this.class_name,
    required this.attached_code,
    required this.class_type,
    required this.lecturer_name,
    required this.lecturer_account_id,
    required this.student_count,
    required this.start_date,
    required this.end_date,
    required this.status,
  });

  // Factory constructor to create a ClassInfo object from JSON
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      class_id: json['class_id'] ?? '',
      class_name: json['class_name'] ?? '',
      attached_code: json['attached_code'] ?? '',
      class_type: json['class_type'] ?? '',
      lecturer_name: json['lecturer_name'] ?? '',
      lecturer_account_id: json['lecturer_account_id'] ?? '',
      student_count: json['student_count'] ?? '',
      start_date: json['start_date'] ?? 0,
      end_date: json['end_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert ClassInfo object to JSON (optional, for sending data to API)
  Map<String, dynamic> toJson() {
    return {
      'class_id': class_id,
      'class_name': class_name,
      'attached_code': attached_code,
      'class_type': class_type,
      'lecturer_name': lecturer_name,
      'lecturer_account_id': lecturer_account_id,
      'student_count': student_count,
      'start_date': start_date,
      'end_date': end_date,
      'status': status,
    };
  }
}
