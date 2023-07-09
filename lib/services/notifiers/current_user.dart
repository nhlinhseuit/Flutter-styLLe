import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_users.dart';

class CurrentUser extends ChangeNotifier {
  late MyUser _user;

  MyUser get user => _user;

  set user(MyUser value) {
    _user = value;
    // notifyListeners();
  }

  set userFavorites(List<String> favorites) {
    _user.favorites = favorites;
    notifyListeners();
  }
  void setName() {
    notifyListeners();
  }
}