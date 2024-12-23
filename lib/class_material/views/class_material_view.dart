import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:it4788_20241/class/views/class_student_view.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_material/views/class_material_edit_view.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:provider/provider.dart';

import '../../classCtrl/views/class_detail_page.dart';
import '../../home/views/home_view.dart';
import '../../utils/get_material_icon.dart';
import '../models/class_material_model.dart';

class ClassMaterialPage extends StatefulWidget {
  final ClassData classData;
  ClassMaterialPage({required this.classData});
  @override
  _ClassMaterialPageState createState() => _ClassMaterialPageState();
}

class _ClassMaterialPageState extends State<ClassMaterialPage> {
  late String classCode, className;
  @override
  void initState() {
    super.initState();
    classCode = widget.classData.classId;
    className = widget.classData.className;
    final viewModel = Provider.of<ClassMaterialViewModel>(context, listen: false);
    viewModel.classData = widget.classData;
    viewModel.getClassMaterials(widget.classData.classId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassMaterialViewModel>(context);

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (viewModel.userData.role == "LECTURER")
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDetailPage(classData: widget.classData),
                  ),
                );
              else
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassStudentPage(),
                  ),
                );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Text(
              className,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          ),
          actions: <Widget>[
            if (viewModel.userData.role == "LECTURER")
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClassMaterialUploadFilePage()));
                },
              ),
          ],
          bottom: TabBar(
            onTap: (int index) {
              viewModel.onClickTabBar(index, context);
            },
            indicatorColor: Colors.red,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            tabs: [
              Tab(text: "Kiểm tra"),
              Tab(text: "Tài liệu"),
              Tab(text: "Khác")
            ],
          ),
          backgroundColor: Colors.red,
        ),
        body: Consumer<ClassMaterialViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.getMaterialList().length,
              itemBuilder: (context, index) {
                final item = viewModel.getMaterialList()[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              getMaterialIcon(item.material_type),
                              width: 40,
                              height: 40,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.material_name, style: TextStyle(fontSize: 16)),
                                Text(item.description),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              showFileOptions(context, item);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  void showFileOptions(BuildContext context, ClassMaterial classMaterial) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final viewModel = Provider.of<ClassMaterialViewModel>(context);
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                classMaterial.material_name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.open_in_new),
                title: Text('Mở'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.drive_file_rename_outline),
                title: Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassMaterialEditPage(
                        classMaterial: classMaterial,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.deleteMaterial(classMaterial);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Xóa tài liệu thành công!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Chia sẻ'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.link),
                title: Text('Sao chép liên kết'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}