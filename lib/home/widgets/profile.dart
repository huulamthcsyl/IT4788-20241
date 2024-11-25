import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

class Profile extends StatelessWidget {

  final UserData userData;

  const Profile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Xin chào, ${userData.ho} ${userData.ten}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          )
        ),
      ],
    );
  }
}
