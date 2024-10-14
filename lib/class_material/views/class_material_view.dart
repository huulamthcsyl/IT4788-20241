import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';

class ClassMaterialPage extends StatelessWidget{
  final List<Map<String, String>> Class_Materials = [
  {'title': 'picture.png', 'subtitle': 'PNG'},
  {'title': 'picture.jpg', 'subtitle': 'JPG'},
  {'title': 'lecture.docx', 'subtitle': 'WORD DOCUMENT'},
  {'title': 'baocao.pdf', 'subtitle': 'PDF'},
  {'title': 'thongke.xlsx', 'subtitle': 'EXCEL'},
  ];
  final List<Map<String, String>> Class_Tests = [
    {'title': 'Test 1', 'subtitle': 'Week 1 Exam'},
    {'title': 'Test 2', 'subtitle': 'Week 2 Exam'},
    {'title': 'Test 3', 'subtitle': 'Week 3 Exam'},
    {'title': 'Test 4', 'subtitle': 'Week 4 Exam'},
    {'title': 'Test 5', 'subtitle': 'Week 5 Exam'},
  ];
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
            indicatorColor: Colors.red,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(
                text: "Kiểm tra"),
            Tab(
                text: "Tài liệu")
          ],
      ),

      ),
  body: TabBarView(children: <Widget>[
    _buildListView(Class_Tests),
    _buildListView(Class_Materials)
  ] )
    ));
  }

  ListView _buildListView(List<Map<String, String>> items) {

    Widget column = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Title', style: TextStyle(fontSize: 16),),
          Text('subtitle'),
        ],
      ),
    );
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index)
        {
          final item = items[index];
          Widget column = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // align text to the left
              children: <Widget>[
                Text(item['title']!, style: TextStyle(fontSize: 16)),
                Text(item['subtitle']!),
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
                      _showFileOptions(context, item['title']!);
                    },
                  )
                ],
              ),
            ),
          );
        });
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