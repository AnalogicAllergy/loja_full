import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedItemSize.name;
  }
  CartProduct.fromDocument(DocumentSnapshot cartItem) {
    id = cartItem.documentID;
    productId = cartItem.data['pid'] as String;
    quantity = cartItem.data['quantity'] as int;
    size = cartItem.data['size'] as String;
    firestore
        .document('products/$productId')
        .get()
        .then((DocumentSnapshot doc) {
      product = Product.fromDocument(doc);
      notifyListeners();
    });
  }
  final Firestore firestore = Firestore.instance;
  String productId;
  int quantity;
  String size;
  String id;

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  Product product;

  Map<String, dynamic> toCartItemMap() {
    return <String, dynamic>{
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedItemSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  num get totalPrice => unitPrice * quantity;
}
