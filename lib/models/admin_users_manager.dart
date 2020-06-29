import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<User> users = [];
  final Firestore firestore = Firestore.instance;
  StreamSubscription subscription;

  void updateUser(UserManager userManager) {
    subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    subscription =
        firestore.collection('users').snapshots().listen((QuerySnapshot value) {
      users = value.documents.map((e) => User.fromDocument(e)).toList();
      users.sort((User a, User b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((User e) => e.name).toList();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
