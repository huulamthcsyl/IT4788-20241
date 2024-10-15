import 'package:flutter/cupertino.dart';

class ClassMaterial{
  String fileName;
  String fileDescription;
  DateTime dateModified;
  String classCode;
  String filePath;

  ClassMaterial({
    required this.fileName,
    required this.fileDescription,
    required this.dateModified,
    required this.classCode,
    required this.filePath
  });
}