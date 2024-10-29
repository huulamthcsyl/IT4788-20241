class Assignment {
  String assignmentName;
  String className;
  String classAvatarUrl;
  String instruction;
  String reference;
  String myWork;
  String score;
  String status;
  DateTime dueDate;
  DateTime submittedDate;

  Assignment({
    required this.assignmentName,
    required this.classAvatarUrl,
    required this.className,
    required this.dueDate,
    required this.submittedDate,
    required this.instruction,
    required this.myWork,
    required this.reference,
    required this.score,
    required this.status
  });
}