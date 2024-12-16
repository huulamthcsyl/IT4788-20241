import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_another_function/viewmodels/class_function_viewmodel.dart';
import 'package:it4788_20241/home/views/home_view.dart';
import 'package:provider/provider.dart';
import '../../auth/models/user_data.dart';

class ClassFunctionPage extends StatefulWidget{
  @override
  _ClassFunctionPageState createState() => _ClassFunctionPageState();
}
class _ClassFunctionPageState extends State<ClassFunctionPage>
{
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassFunctionViewModel>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                // Sau thay thế cái này bằng quay về chỗ cũ
                MaterialPageRoute(builder: (context) => HomeView()), // Trang Home
              );
            },
          ),
          title: Text("Class 0000"),
          bottom: TabBar(
            onTap: (int index){
              setState(() {
                viewModel.onClickTabBar(index, context);
              });
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
        body: buildListViewbyRole(viewModel.userData, context, viewModel),
      )
    );
  }
  List<String> lecturerFunctions = ['Xem danh sách điểm danh', 'Xem danh sách đơn xin nghỉ'];
  List<String> studentFunctions = ['Gửi đơn xin vắng mặt'];
  Widget buildListViewbyRole(UserData userData, BuildContext context, ClassFunctionViewModel viewModel)
  {
    List<String> listTitle = userData.role == "LECTURER" ? lecturerFunctions : studentFunctions;
    return
      ListView.builder(
        itemCount: listTitle.length,
        itemBuilder: (context, index) {
          final item = listTitle[index];
          Widget column = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item!, style: TextStyle(fontSize: 16)),
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
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        viewModel.onSelectAction(userData.role, index, context);
                      });
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
  }
}