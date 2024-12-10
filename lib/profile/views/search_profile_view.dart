import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../search/views/search_view.dart';

class ViewSearchProfilePage extends StatefulWidget
{
  final String accountId;
  ViewSearchProfilePage({required this.accountId});

  @override
  _viewSearchProfilePageState createState() => _viewSearchProfilePageState();
}

class _viewSearchProfilePageState extends State<ViewSearchProfilePage> {
  late int userID;

  @override
  void initState() {
    super.initState();
    userID = int.tryParse(widget.accountId) ?? 0;
    final _profileviewmodel = Provider.of<ProfileViewModel>(context, listen: false);
    _profileviewmodel.getInformationFromUser(userID);
  }

  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            (_profileviewmodel.searchUserData.role == "LECTURER"
                ? "THÔNG TIN GIẢNG VIÊN"
                : "THÔNG TIN SINH VIÊN"),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/img/profile_wallpaper.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(_profileviewmodel.searchUserData.avatar.toString()),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_profileviewmodel.searchUserData.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: 'Email: ', style: TextStyle(fontSize: 14)),
                                              TextSpan(
                                                text: _profileviewmodel.searchUserData.email,
                                                style: TextStyle(
                                                    fontSize: 14, decorationColor: Colors.blue, color: Colors.blue, decoration: TextDecoration.underline),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 10, offset: Offset(0, 3))],
                ),
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ProfileRow(title: (_profileviewmodel.searchUserData.role == "LECTURER" ? "Mã giảng viên" : "Mã sinh viên"), value: _profileviewmodel.searchUserData.id)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ProfileRow(title: 'Email cá nhân:', value: _profileviewmodel.searchUserData.email)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final String value;
  ProfileRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    bool isGmail = value.contains('@gmail');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
          isGmail
              ? Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.blue.withOpacity(0.6), decoration: TextDecoration.underline, decorationColor: Colors.blue, fontWeight: FontWeight.bold),
          )
              : Text(value, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
          Divider(color: Colors.grey, thickness: 1, height: 20),
        ],
      ),
    );
  }
}
