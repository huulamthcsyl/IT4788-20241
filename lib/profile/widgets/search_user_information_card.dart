import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/widgets/profile_row.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';

class SearchUserInformationCard extends StatelessWidget {
  const SearchUserInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3))
        ],
      ),
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ProfileRow(
                      title: (_profileviewmodel.searchUserData.role ==
                          "LECTURER"
                          ? "Mã giảng viên"
                          : "Mã sinh viên"),
                      value: _profileviewmodel.searchUserData.id)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ProfileRow(
                      title: 'Email cá nhân:',
                      value: _profileviewmodel.searchUserData.email)),
            ],
          ),
        ],
      ),
    );
  }
}
