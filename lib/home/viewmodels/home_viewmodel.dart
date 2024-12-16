import 'package:flutter/cupertino.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

import '../../utils/get_data_user.dart';

class HomeViewModel extends ChangeNotifier {
  UserData userData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    email: '',
    status: '',
    role: '',
    avatar: '',
  );

  HomeViewModel() {
    initUserData();
  }

  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }
}