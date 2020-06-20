import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product extends ChangeNotifier {
  List<String> images;
  String name;
  String description;
  String id;
  List<ItemSize> sizes;
  ItemSize _selectedItemSize;
  ItemSize get selectedItemSize => _selectedItemSize;
  set selectedSize(ItemSize itemSize) {
    _selectedItemSize = itemSize;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  Product({this.images, this.name, this.description});

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    name = document['name'] as String;
    description = document['description'] as String;
    sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
