import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDataSource extends DataTableSource {
  final List<ClassInfo> classes;

  ClassDataSource(this.classes);

  @override
  DataRow getRow(int index) {
    final classData = classes[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(classData.classCode)),
        DataCell(Text(classData.linkedClassCode)),
        DataCell(Text(classData.courseCode)),
        DataCell(Text(classData.className)),
        DataCell(Text(classData.schedule)),
        DataCell(Text(classData.classroom)),
        DataCell(Text(classData.credits.toString())),
        DataCell(Text(classData.classType)),
        DataCell(Text(classData.status)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => classes.length;

  @override
  int get selectedRowCount => 0;
}
