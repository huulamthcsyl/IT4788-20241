class ClassInfo {
  String classCode;
  String linkedClassCode;
  String courseCode;
  String className;
  String schedule;
  String classroom;
  int credits;
  String classType;
  String status;

  ClassInfo({
    required this.classCode,
    required this.linkedClassCode,
    required this.courseCode,
    required this.className,
    required this.schedule,
    required this.classroom,
    required this.credits,
    required this.classType,
    required this.status,
  });

  // Factory constructor to create a ClassInfo object from JSON
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classCode: json['classCode'] ?? '',
      linkedClassCode: json['linkedClassCode'] ?? '',
      courseCode: json['courseCode'] ?? '',
      className: json['className'] ?? '',
      schedule: json['schedule'] ?? '',
      classroom: json['classroom'] ?? '',
      credits: json['credits'] ?? 0,
      classType: json['classType'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert ClassInfo object to JSON (optional, for sending data to API)
  Map<String, dynamic> toJson() {
    return {
      'classCode': classCode,
      'linkedClassCode': linkedClassCode,
      'courseCode': courseCode,
      'className': className,
      'schedule': schedule,
      'classroom': classroom,
      'credits': credits,
      'classType': classType,
      'status': status,
    };
  }
}
