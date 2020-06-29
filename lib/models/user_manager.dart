import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }
  User user;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  bool loading = false;
  bool get isLoggedIn => user != null;
  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    setLoading(true);
    try {
      final AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    setLoading(true);
    try {
      final AuthResult result =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;
      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser =
        firebaseUser ?? await firebaseAuth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      final DocumentSnapshot docAdmin =
          await firestore.collection('admins').document(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;

  void signOut() {
    firebaseAuth.signOut();
    user = null;
    notifyListeners();
  }
}
