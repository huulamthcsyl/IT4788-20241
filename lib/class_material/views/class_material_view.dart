import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/views/class_material_edit_view.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:provider/provider.dart';

import '../../home/views/home_view.dart';
import '../models/class_material_model.dart';

class ClassMaterialPage extends StatefulWidget {
  final String classCode;
  ClassMaterialPage({required this.classCode});
  @override
  _ClassMaterialPageState createState() => _ClassMaterialPageState();
}

class _ClassMaterialPageState extends State<ClassMaterialPage> {
  late String classCode;
  @override
  void initState() {
    super.initState();
    classCode = widget.classCode;
    final viewModel = Provider.of<ClassMaterialViewModel>(context, listen: false);
    viewModel.getClassMaterials(classCode);
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
          ),
          title: Text("OOP 2024.1"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
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
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Kiểm tra"),
              Tab(text: "Tài liệu"),
              Tab(text: "Chức năng khác")
            ],
          ),
        ),
        body: Consumer<ClassMaterialViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.getMaterialList().isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: viewModel.getMaterialList().length,
                itemBuilder: (context, index) {
                  final item = viewModel.getMaterialList()[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
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
                  );
                },
              );
            }
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