import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';

class ClassMaterialPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2
        , child: Scaffold(
      appBar: AppBar(
              leading: BackButton(),
        title: Text("OOP 2024.1"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialUploadFilePage()));
            },
          ),
        ],
        bottom: TabBar(
          tabs: [
            Tab(
                text: "Kiểm tra"),
            Tab(
                text: "Tài liệu")
          ],
      ),
      ),
  body: TabBarView(children: <Widget>[
        _buildListViewWithName('Test Week'),
        _buildListViewWithName('File Material')
  ] )
    ));
  }
  ListView _buildListViewWithName(String s) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(s + ' $index'),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            _showFileOptions(context, s + ' $index');
          },
        ),
      ),
    );
  }

  void _showFileOptions(BuildContext context, String fileName) {
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
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.offline_pin),
                title: Text('Làm có sẵn ngoại tuyến'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.drive_file_rename_outline),
                title: Text('Đổi tên'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Chia sẻ'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.link),
                title: Text('Sao chép liên kết'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.send),
                title: Text('Gửi một bản'),
                onTap: () {
                },
              ),
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Mở trong ứng dụng'),
                onTap: () {
                },
              ),
            ],
          ),
        );
      },
    );
  }

}