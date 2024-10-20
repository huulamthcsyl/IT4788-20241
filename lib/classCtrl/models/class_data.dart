class ClassData {
  String classId; // Mã lớp
  String classCode; // Mã lớp kèm
  String linkedClassCode; // Mã lớp liên kết
  String courseCode; // Mã khóa học
  String className; // Tên lớp
  String schedule; // Lịch học
  String classroom; // Phòng học
  int credits; // Số tín chỉ
  String classType; // Loại lớp
  String status; // Trạng thái
  bool isSelected; // Được chọn hay không
  int maxStudents; // Số học sinh tối đa
  List<Student> studentList; // Danh sách học sinh
  //String classTimeStart;
  //String classTimeEnd;

  ClassData({
    required this.classId,
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
    required this.maxStudents,
    //required this.classTimeEnd,
    //required this.classTimeStart,
    List<Student>? students,
  }) : studentList = students ?? [];
}

class Student {
  String name;

  Student(this.name);
}