import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';

class SearchUserMainCard extends StatelessWidget {
  const SearchUserMainCard({super.key});
  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return Card(
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
                                    image: _profileviewmodel.searchUserData.avatar != null
                                        ? (NetworkImage(_profileviewmodel.convertGoogleDriveLink(_profileviewmodel.searchUserData.avatar.toString())) == null ?
                                      AssetImage('assets/img/default_avatar.jpg') as ImageProvider : NetworkImage(_profileviewmodel.convertGoogleDriveLink(_profileviewmodel.searchUserData.avatar.toString()))
                                    )
                                        : AssetImage(
                                        'assets/img/default_avatar.jpg') as ImageProvider,
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
                          Text(_profileviewmodel.searchUserData.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Email: ',
                                    style: TextStyle(fontSize: 14)),
                                TextSpan(
                                  text: _profileviewmodel.searchUserData.email,
                                  style: TextStyle(
                                      fontSize: 14,
                                      decorationColor: Colors.blue,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
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
    );
  }
}