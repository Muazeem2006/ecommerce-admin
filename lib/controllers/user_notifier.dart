import 'package:flutter/material.dart';
import '../models/user.dart';

class UserNotifier extends ChangeNotifier {
  List<User> userList = [];

  // adding user
  addUser(User user) {
    userList.add(user);
    notifyListeners();
  }

  // deleting user
  deleteUser(User user) {
    userList.remove(user);
    notifyListeners();
  }

  // loading user from the database into provider
  UserNotifier.all(List<User> users) {
    userList = users;
    notifyListeners();
  }
}
