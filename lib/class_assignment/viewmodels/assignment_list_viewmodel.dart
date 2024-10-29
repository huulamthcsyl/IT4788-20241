import 'package:flutter/material.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';

class AssignmentListViewModel extends ChangeNotifier {
  List<Assignment> assignmentList = [
    Assignment(
      assignmentName: 'Math Homework',
      classAvatarUrl: 'url_to_avatar',
      className: 'Math 101',
      dueDate: DateTime.parse('2023-10-10T10:00:00'),
      submittedDate: DateTime.parse('2023-10-09T10:00:00'),
      instruction: 'Solve all exercises in Chapter 5',
      myWork: 'Submitted PDF',
      reference: 'Chapter 5 of the textbook',
      score: '10',
      status: 'Completed',
    ),
    Assignment(
      assignmentName: 'Science Project',
      classAvatarUrl: 'url_to_avatar',
      className: 'Science 101',
      dueDate: DateTime.parse('2023-10-15T10:00:00'),
      submittedDate: DateTime.parse('2023-10-14T10:00:00'),
      instruction: 'Build a model of the solar system',
      myWork: 'Submitted model',
      reference: 'Chapter 7 of the textbook',
      score: '9',
      status: 'Upcoming',
    ),
    Assignment(
      assignmentName: 'History Essay',
      classAvatarUrl: 'url_to_avatar',
      className: 'History 101',
      dueDate: DateTime.parse('2023-10-20T10:00:00'),
      submittedDate: DateTime.parse('2023-10-19T10:00:00'),
      instruction: 'Write an essay on World War II',
      myWork: 'Submitted essay',
      reference: 'Chapter 10 of the textbook',
      score: '8',
      status: 'Completed',
    ),
    Assignment(
      assignmentName: 'English Literature',
      classAvatarUrl: 'url_to_avatar',
      className: 'English 101',
      dueDate: DateTime.parse('2023-10-25T10:00:00'),
      submittedDate: DateTime.parse('2023-10-24T10:00:00'),
      instruction: 'Read and analyze "To Kill a Mockingbird"',
      myWork: 'Submitted analysis',
      reference: 'Chapter 3 of the textbook',
      score: '10',
      status: 'Past due',
    ),
  ];

  String searchQuery = '';
  String selectedStatus = 'Upcoming';

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  List<Assignment> get filteredAssignments {
    return assignmentList.where((assignment) {
      return assignment.status == selectedStatus &&
          assignment.assignmentName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}