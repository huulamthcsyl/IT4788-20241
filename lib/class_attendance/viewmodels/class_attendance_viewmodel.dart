import 'dart:math';
import 'package:it4788_20241/class_attendance/models/class_attendance_model.dart';
import 'package:flutter/material.dart';
int countMember = 0;
class ClassAttendanceViewModel extends ChangeNotifier
{
  late List<classMember> _classMember;
  List<classMember> getClassMembers(String classCode) {
    // Trong trường hợp có Database rồi thì truy vấn database để lấy file dựa trên classCode
    Random random = new Random();
    List<classMember> listMembers = List.generate(10, (index) => classMember(
        memberName: 'Student${index + 1}',
        memberCode: '${random.nextInt(9999)}',
        countAbsent: random.nextInt(5),
        classCode: classCode,
        checkAttendance: false
      // Use the classCode parameter here
    ));
    countMember = listMembers.length;
    return listMembers;
  }
  void onSubmitAttendance()
  {

  }
  List<bool> checkList = List.filled(countMember, false);
  void checkAttendance(classMember member, index){
    checkList[index] = !checkList[index];
    member.checkAttendance = checkList[index];
  }

}