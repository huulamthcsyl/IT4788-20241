import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';

class AssignmentDetailViewModel extends ChangeNotifier {
  final Assignment assignment;

  AssignmentDetailViewModel({required this.assignment});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}