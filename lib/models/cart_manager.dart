import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = <CartProduct>[];
  User user;
  num productsPrice = 0.0;

  void addToCart(Product product) {
    //stacking products on cart
    try {
      final e =
          items.firstWhere((CartProduct element) => element.stackable(product));
      e.increment();
    } catch (e) {
      final CartProduct cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((value) => cartProduct.id = value.documentID);
      _onItemUpdated();
    }
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();
    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnapshot = await user.cartReference.getDocuments();
    items = cartSnapshot.documents
        .map((DocumentSnapshot cartItem) =>
            CartProduct.fromDocument(cartItem)..addListener(_onItemUpdated))
        .toList();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final CartProduct cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeFromCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null)
      user.cartReference
          .document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
  }

  void removeFromCart(CartProduct cartProduct) {
    items.removeWhere((element) => element.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  bool get isCartValid {
    for (final CartProduct cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }
}
