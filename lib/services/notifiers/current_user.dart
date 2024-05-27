import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_users.dart';

class CurrentUser extends ChangeNotifier {
  // late MyUser _user;
  
  MyUser _user = MyUser(
    uid: 'uid',
    firstName: 'firstName',
    lastName: 'lastName',
    email: 'email',
    favorites: [],
    deleted: false,
  );

  MyUser get user => _user;

  set user(MyUser value) {
    _user = value;
    // notifyListeners();
  }

  set userFavorites(List<String> favorites) {
    _user.favorites = favorites;
    notifyListeners();
  }

  set userReports(List<String> reports) {
    _user.reports = reports;
    notifyListeners();
  }

  void setName() {
    notifyListeners();
  }

  void setProfileImage() {
    notifyListeners();
  }
}
