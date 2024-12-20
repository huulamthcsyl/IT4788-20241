import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_list_viewmodel.dart';
import '../widgets/class_detail_dialog.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {

  @override
  void dispose() {
    final classListViewModel = Provider.of<ClassListViewModel>(context, listen: false);
    classListViewModel.searchController.dispose(); // Giải phóng bộ nhớ từ ViewModel
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
                    controller: classListViewModel.searchController,
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
                      classListViewModel.searchClasses(classListViewModel.searchController.text.trim());
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: displayedClasses.length,
                itemBuilder: (context, index) {
                  final classInfo = displayedClasses[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(classInfo.class_name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mã lớp: ${classInfo.class_id}'),
                          Text('Loại lớp: ${classInfo.class_type}'),
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => ClassDetailsDialog(classInfo: classInfo),
                          );
                        },
                        child: Text('Chi tiết', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  );
                },
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
