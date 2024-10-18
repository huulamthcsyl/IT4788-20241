import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_list_viewmodel.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classListViewModel = Provider.of<ClassListViewModel>(context);
    final displayedClasses = classListViewModel.getDisplayedClasses();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách các lớp mở', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Nhập mã học phần hoặc mã lớp',
                      labelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintStyle: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                    onSubmitted: (value) {
                      classListViewModel.searchClasses(_searchController.text.trim());
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.red),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(child: Text('Mã lớp', style: TextStyle(color: Colors.white))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(child: Text('Mã HP', style: TextStyle(color: Colors.white))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(child: Text('Tên lớp', style: TextStyle(color: Colors.white))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(child: Text('Chi tiết', style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                    for (var classInfo in displayedClasses)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Center(child: Text(classInfo.classCode)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Center(child: Text(classInfo.courseCode)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Center(child: Text(classInfo.className)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Center(
                              child: TextButton(
                                onPressed: () => classListViewModel.showClassDetails(context, classInfo),
                                child: Text('Chi tiết', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: classListViewModel.canGoBack ? () => classListViewModel.previousPage() : null,
                  icon: Icon(Icons.arrow_back),
                ),
                Text('Trang ${classListViewModel.currentPage + 1}'),
                IconButton(
                  onPressed: classListViewModel.canGoForward ? () => classListViewModel.nextPage() : null,
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
