import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/viewmodels/assignment_detail_viewmodel.dart';

class AssignmentDetailView extends StatelessWidget {
  final Assignment assignment;

  const AssignmentDetailView({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentDetailViewModel(assignment: assignment),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assignment Details'),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AssignmentDetailViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.assignment.status == 'Completed')
                    Text(
                      'Submitted at ${viewModel.formatDateTime(viewModel.assignment.submittedDate)}',
                      style: const TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    viewModel.assignment.assignmentName,
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Due at ${viewModel.formatDateTime(viewModel.assignment.dueDate)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Instructions:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    viewModel.assignment.instruction,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'References:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    viewModel.assignment.reference,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'My Work:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Attach'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('New'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Score:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    viewModel.assignment.score,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}