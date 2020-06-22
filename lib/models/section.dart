import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section {
  Section.fromDocument(DocumentSnapshot document) {
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List)
        .map((section) => SectionItem.fromMap(section as Map<String, dynamic>))
        .toList();
  }
  String name;
  String type;
  List<SectionItem> items;
}
