import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:it4788_20241/class_assignment/repositories/assignment_repository.dart';

class AssignmentService {
  final assignmentRepository = AssignmentRepository();

  Future<int> createAssignment(
      String? token,
      String classId,
      String description,
      String title,
      DateTime deadline,
      List<PlatformFile> files) async {
    return await assignmentRepository.createAssignment(
        token, classId, description, title, deadline, files);
  }

  Future<void> editAssignment(String? token, int assignmentId,
      String description, DateTime deadline, List<PlatformFile> files) async {
    return await assignmentRepository.editAssignment(
        token, assignmentId, description, deadline, files);
  }

  Future<void> deleteAssignment(String? token, int assignmentId) async {
    return await assignmentRepository.deleteAssignment(token, assignmentId);
  }

  Future<List<SubmissionData>> fetchAssignmentResponse(
      String? token, int assignmentId, double? score, int? submissionId) async {
    return await assignmentRepository.fetchAssignmentResponse(
        token, assignmentId, score, submissionId);
  }

  Future<List<AssignmentData>> fetchAssignmentListWithType(
      String? token, String type, String classId) async {
    return await assignmentRepository.fetchAssignmentListWithType(
        token, type, classId);
  }

  Future<List<AssignmentData>> fetchAllAssignment(
      String? token, String classId) async {
    return await assignmentRepository.fetchAllAssignment(token, classId);
  }

  Future<SubmissionData> fetchSubmission(
      String? token, int assignmentId) async {
    return await assignmentRepository.fetchSubmission(token, assignmentId);
  }

  Future<String> submitAssignment(String? token, int assignmentId,
      String textResponse, List<PlatformFile> files) async {
    return await assignmentRepository.submitAssignment(
        token, assignmentId, textResponse, files);
  }
}
