import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../search/views/search_view.dart';
import '../widgets/search_user_information_card.dart';
import '../widgets/search_user_main_card.dart';

class ViewSearchProfilePage extends StatefulWidget {
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
    final _profileviewmodel =
    Provider.of<ProfileViewModel>(context, listen: false);
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
                  child: SearchUserMainCard(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchUserInformationCard(),
            ),
          ],
        ),
      ),
    );
  }
}