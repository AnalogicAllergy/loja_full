import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String password;
  String name;
  String confirmedPassword;
  String id;

  DocumentReference get firestoreReference =>
      Firestore.instance.document('users/$id');

  User({this.email, this.password, this.name, this.confirmedPassword, this.id});
  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
  }
  Future<void> saveData() async {
    await firestoreReference.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }
}
