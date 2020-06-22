import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(builder: (_, cartManager, __) {
        return ListView(
          children: <Widget>[
            Column(
                children: cartManager.items
                    .map((CartProduct cartProduct) => CartTile(
                          cartProduct: cartProduct,
                        ))
                    .toList()),
            PriceCard(
              buttonText: 'Continuar para Entrega',
              onPress: cartManager.isCartValid ? () {} : null,
            )
          ],
        );
      }),
    );
  }
}
