import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer/custom_icon_button.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  const CartTile({Key key, this.cartProduct}) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(cartProduct.product.images.first),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        cartProduct.product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Tamanho: ${cartProduct.size}',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Consumer<CartProduct>(
                        builder: (_, cartProduct, __) {
                          if (cartProduct.hasStock) {
                            return Text(
                              'R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text(
                              'Sem estoque disponivel',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Consumer<CartProduct>(builder: (_, CartProduct cartProduct, __) {
                return Column(
                  children: <Widget>[
                    CustomIconButton(
                      iconData: Icons.add,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        cartProduct.increment();
                      },
                    ),
                    Text(
                      '${cartProduct.quantity}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    CustomIconButton(
                      iconData: Icons.remove,
                      color: cartProduct.quantity > 1
                          ? Theme.of(context).primaryColor
                          : Colors.red,
                      onTap: () {
                        cartProduct.decrement();
                      },
                    ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
