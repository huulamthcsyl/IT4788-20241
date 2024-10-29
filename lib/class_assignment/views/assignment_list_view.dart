import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_assignment/widgets/assignment_item.dart';
import 'package:it4788_20241/class_assignment/views/assignment_detail_view.dart';
import 'package:it4788_20241/class_assignment/viewmodels/assignment_list_viewmodel.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';

class AssignmentListView extends StatelessWidget {
  const AssignmentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentListViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Assignments"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  context.read<AssignmentListViewModel>().updateSearchQuery(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter assignment name',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
                textInputAction: TextInputAction.search,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusButton(context, 'Upcoming'),
                  _buildStatusButton(context, 'Past due'),
                  _buildStatusButton(context, 'Completed'),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AssignmentListViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    itemCount: viewModel.filteredAssignments.length,
                    itemBuilder: (context, index) {
                      Assignment assignment = viewModel.filteredAssignments[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 16.0, left: 16.0, right: 16.0),
                            child: Text(
                              viewModel.formatDate(assignment.dueDate.toString()),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          AssignmentItem(
                            avatarUrl: assignment.classAvatarUrl,
                            assignmentName: assignment.assignmentName,
                            submissionTime: assignment.submittedDate.toString(),
                            className: assignment.className,
                            status: assignment.status,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssignmentDetailView(assignment: assignment),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, String status) {
    return Consumer<AssignmentListViewModel>(
      builder: (context, viewModel, child) {
        return ElevatedButton(
          onPressed: () {
            viewModel.updateSelectedStatus(status);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.selectedStatus == status
                ? const Color(0xFF5D13E7)
                : const Color(0xFFEEEEEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: viewModel.selectedStatus == status ? Colors.white : Colors.black,
              fontWeight: viewModel.selectedStatus == status
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }
}