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
  bool isSelected;

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
    this.isSelected = false,
  });
}
