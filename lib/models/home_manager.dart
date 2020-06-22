import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }
  final Firestore firestore = Firestore.instance;
  List<Section> sections = [];

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) {
      sections.clear();
      for (final DocumentSnapshot documentSnapshot in snapshot.documents) {
        sections.add(Section.fromDocument(documentSnapshot));
      }
      notifyListeners();
    });
  }
}
