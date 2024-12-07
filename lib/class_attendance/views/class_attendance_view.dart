
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_attendance/models/class_attendance_model.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_attendance_viewmodel.dart';

class ClassAttendancePage extends StatefulWidget {
  @override
  _ClassAttendancePageState createState() => _ClassAttendancePageState();
}
class _ClassAttendancePageState extends State<ClassAttendancePage>
{
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceViewModel>(context);
    final members = viewModel.getClassMembers("287278");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20
        ),
        leading: BackButton(color: Colors.white),
        title: Text("Điểm danh lớp 139999"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              viewModel.onSubmitAttendance();
            },
          ),
        ],
      ),
      body:
      ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CheckboxListTile(
                      title: Text("${index + 1}. ${member.memberName!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text("MSSV: ${member.memberCode!}", style: TextStyle(fontSize: 16)),
                      activeColor: Colors.red,
                      value: viewModel.checkList[index],
                      onChanged: (bool? value){
                        setState(() {
                            viewModel.checkAttendance(member, index);
                        });
                      }
                  )

              ),
            );
          })
    );
  }
}