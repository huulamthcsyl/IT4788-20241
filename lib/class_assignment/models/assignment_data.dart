import 'dart:convert';
import 'dart:ffi';

AssignmentData assignmentDataFromJson(String str) =>
    AssignmentData.fromJson(json.decode(str));

String assignmentDataToJson(AssignmentData data) => json.encode(data.toJson());

class AssignmentData {
  int id;
  String title;
  String description;
  int lecturerId;
  String deadline;
  String fileUrl;
  bool isSubmitted;
  String classId;

  AssignmentData(
      {required this.id,
      required this.title,
      required this.description,
      required this.lecturerId,
      required this.deadline,
      required this.fileUrl,
      required this.isSubmitted,
      required this.classId});

  factory AssignmentData.fromJson(Map<String, dynamic> json) => AssignmentData(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        lecturerId: json['lecturer_id'],
        deadline: json['deadline'],
        fileUrl: json['file_url'] ?? '',
        isSubmitted: json['is_submitted'] ?? false,
        classId: json['class_id'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "lecturer_id": lecturerId,
        "deadline": deadline,
        "class_id": classId,
      };
}
