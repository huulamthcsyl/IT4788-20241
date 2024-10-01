import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/class_data.dart';
import 'package:it4788_20241/auth/viewmodels/classCtrl_viewmodel.dart';

class ClassCtrlView extends StatefulWidget {
  @override
  _ClassCtrlViewState createState() => _ClassCtrlViewState();
}

class _ClassCtrlViewState extends State<ClassCtrlView> {
  // List<ClassData> classes = [];

  // Tạo dữ liệu để hiển thị trên màn hình
  List<ClassData> classes = [
    ClassData('Lớp 1A', 30),
    ClassData('Lớp 2B', 25),
    ClassData('Lớp 3C', 20),
    ClassData('Lớp 4D', 15),
    ClassData('Lớp 5E', 10),
  ];

  void _addClass(ClassData newClass) {
    setState(() {
      classes.add(newClass);
    });
  }

  void _editClass(int index, ClassData updatedClass) {
    setState(() {
      classes[index] = updatedClass;
    });
  }

  void _deleteClass(int index) {
    setState(() {
      classes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý lớp')),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(classes[index].name),
            subtitle: Text('Số lượng sinh viên: ${classes[index].studentCount}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassCtrlViewModel(
                          classData: classes[index],
                          onSave: (classData) => _editClass(index, classData),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteClass(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassCtrlViewModel(onSave: _addClass),
            ),
          );
        },
      ),
    );
  }
}