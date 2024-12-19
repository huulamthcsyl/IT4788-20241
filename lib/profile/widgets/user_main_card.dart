import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';
import 'change_avatar_dialog.dart';

class UserMainCard extends StatefulWidget {
  const UserMainCard({super.key});

  @override
  State<UserMainCard> createState() => _UserMainCardState();
}

class _UserMainCardState extends State<UserMainCard> {
  late File _selectedImage = File('');
  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return Card(color: Colors.white.withOpacity(0.9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(padding: const EdgeInsets.all(7.0),
  child: Column(
    children: [Stack(
      children: [Row(
        children: [Stack(
          children: [ClipRRect(borderRadius: BorderRadius.circular(15.0),
            child: Container(height: 100.0, width: 100.0, decoration: BoxDecoration(image: DecorationImage(image: _profileviewmodel.userData.avatar != null ? (NetworkImage(_profileviewmodel.convertGoogleDriveLink(_profileviewmodel.userData.avatar.toString())) == null ? AssetImage('assets/img/default_avatar.jpg') as ImageProvider : NetworkImage(_profileviewmodel.convertGoogleDriveLink(_profileviewmodel.userData.avatar.toString()))) : AssetImage('assets/img/default_avatar.jpg') as ImageProvider, fit: BoxFit.cover)))),
            Positioned.fill(
                child: Align(alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {setState(() {_selectedImage = File('');showDialog(context: context, builder: (BuildContext context) {return ChangeAvatarDialog(selectedImage: _selectedImage);});});},
                      child: Container(padding: EdgeInsets.all(10.0), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
                          child: Icon(Icons.camera_alt, color: Colors.white)))))]),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_profileviewmodel.userData.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text.rich(TextSpan(
                              children: [
                                  TextSpan(text: 'Email: ', style: TextStyle(fontSize: 14)),
                                  TextSpan(text: _profileviewmodel.userData.email, style: TextStyle(fontSize: 14, decorationColor: Colors.blue, color: Colors.blue, decoration: TextDecoration.underline))],))]))])])])));
  }
}