import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:provider/provider.dart';
class ClassMaterialPage extends StatefulWidget {
  @override
  _ClassMaterialPageState createState() => _ClassMaterialPageState();
}

class _ClassMaterialPageState extends State<ClassMaterialPage>
{
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassMaterialViewModel>(context);
    final classMaterials = viewModel.getClassMaterials("199289");
    return DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(),
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
              onTap: (int index)
                  {
                    setState(()
                  {
                      viewModel.onClickTabBar(index, context);
                  });
              },
              indicatorColor: Colors.red,
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "Kiểm tra"),
                Tab(text: "Tài liệu")
              ],
            ),
          ),
          body:
            ListView.builder(
            itemCount: classMaterials.length,
            itemBuilder: (context, index) {
              final viewModel = Provider.of<ClassMaterialViewModel>(context);
              final item = classMaterials[index];
              Widget column = Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.fileName!, style: TextStyle(fontSize: 16)),
                    Text(item.fileDescription!),
                  ],
                ),
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      column,
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          showFileOptions(context, item.fileName!);
                        },
                      )
                    ],
                  ),
                ),
              );
            }) // Use the current tab index to control the list view
        ));
  }
  void showFileOptions(BuildContext context, String fileName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                fileName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.open_in_new),
                title: Text('Mở'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.offline_pin),
                title: Text('Làm có sẵn ngoại tuyến'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.drive_file_rename_outline),
                title: Text('Đổi tên'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {},
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
              ListTile(
                leading: Icon(Icons.send),
                title: Text('Gửi một bản'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Mở trong ứng dụng'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
