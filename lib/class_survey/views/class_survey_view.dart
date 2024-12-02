import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/class_material/views/class_material_view.dart';
class ClassSurveyPage extends StatefulWidget {
  @override
  _ClassSurveyPageState createState() => _ClassSurveyPageState();
}

class _ClassSurveyPageState extends State<ClassSurveyPage> {
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

  int tabIndex = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
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
              onTap: (int index) {
                setState(() {
                  tabIndex = index; // Update the tabIndex when a tab is tapped
                  if (tabIndex == 1) {

                    Navigator.push((context), MaterialPageRoute(
                        builder: (context) => ClassMaterialPage()));
                  }
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
          body: _buildListView(), // Use the current tab index to control the list view
        ));
  }

  ListView _buildListView() {
    List<Map<String, String>> items;
    String type;
      items = Class_Tests;
      type = "class_tests";

    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          Widget column = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      _showFileOptions(context, item['title']!, type);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showFileOptions(BuildContext context, String fileName, String type) {
    if (type == "class_materials") {
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
    } else {

    }
  }
}
