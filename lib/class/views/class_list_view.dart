import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_list_viewmodel.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 20;

  void _searchClasses() {
    final classListViewModel = Provider.of<ClassListViewModel>(context, listen: false);
    String searchCode = _searchController.text.trim();
    classListViewModel.searchClasses(searchCode);
    _currentPage = 0; // Reset trang về 0 khi tìm kiếm
  }

  @override
  Widget build(BuildContext context) {
    final classListViewModel = Provider.of<ClassListViewModel>(context);
    final classes = classListViewModel.classes;

    // Tính toán chỉ số lớp hiển thị theo trang
    final int start = _currentPage * _rowsPerPage;
    final int end = start + _rowsPerPage > classes.length ? classes.length : start + _rowsPerPage;
    final displayedClasses = classes.sublist(start, end);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách các lớp mở',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Nhập mã học phần',
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
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  onPressed: _searchClasses,
                  child: Text('Tìm kiếm', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Cho phép cuộn dọc
                  child: Container(
                    width: MediaQuery.of(context).size.width * 2.5, // Rộng hơn màn hình để có thể cuộn ngang
                    child: Table(
                      border: TableBorder.all(color: Colors.black), // Viền bảng màu đen
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(80),
                        1: FixedColumnWidth(80),
                        2: FixedColumnWidth(80),
                        3: FixedColumnWidth(150),
                        4: FixedColumnWidth(150),
                        5: FixedColumnWidth(100),
                        6: FixedColumnWidth(50),
                        7: FixedColumnWidth(80),
                        8: FixedColumnWidth(100),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        // Tiêu đề bảng
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.red, // Nền màu đỏ cho hàng tiêu đề
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Mã lớp', style: TextStyle(color: Colors.white))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Mã lớp kèm', style: TextStyle(color: Colors.white))),
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
                              child: Center(child: Text('Lịch học', style: TextStyle(color: Colors.white))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Phòng học', style: TextStyle(color: Colors.white))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Số TC', style: TextStyle(color: Colors.white))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Loại lớp', style: TextStyle(color: Colors.white))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Center(child: Text('Trạng thái', style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        ),
                        // Dữ liệu bảng
                        for (int i = 0; i < displayedClasses.length; i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].classCode)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].linkedClassCode)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].courseCode)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].className)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].schedule)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].classroom)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].credits.toString())),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].classType)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(child: Text(displayedClasses[i].status)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                  icon: Icon(Icons.arrow_back),
                ),
                Text('Trang ${_currentPage + 1}'),
                IconButton(
                  onPressed: end < classes.length ? () => setState(() => _currentPage++) : null,
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
