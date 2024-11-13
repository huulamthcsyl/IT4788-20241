import 'package:flutter/cupertino.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

class Profile extends StatelessWidget {

  final UserData userData;

  const Profile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${userData.ho} + ${userData.ten}'),
      ],
    );
  }
}
