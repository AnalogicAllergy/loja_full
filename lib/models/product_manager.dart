import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }
  final Firestore firestore = Firestore.instance;
  List<Product> allProducts = [];
  String _search = '';
  String get search => _search;
  set search(String search) {
    _search = search;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (_search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      for (final Product product in allProducts) {
        if (product.name.toLowerCase().contains(_search.toLowerCase())) {
          filteredProducts.add(product);
        }
      }
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot productSnapshots =
        await firestore.collection('products').getDocuments();
    allProducts =
        productSnapshots.documents.map((e) => Product.fromDocument(e)).toList();
    notifyListeners();
  }

  Product findProductById(String productId) {
    try {
      return allProducts.firstWhere((element) => element.id == productId);
    } catch (e) {
      return null;
    }
  }
}
