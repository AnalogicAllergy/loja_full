import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              return productManager.search.isEmpty
                  ? IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final String search = await showDialog<String>(
                            context: context, builder: (_) => SearchDialog());
                        if (search != null) {
                          productManager.search = search;
                        }
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        productManager.search = '';
                      },
                    );
            },
          )
//          ),IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {},
//          )
        ],
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            return productManager.search.isEmpty
                ? Text("Produtos")
                : LayoutBuilder(
                    builder: (_, constraints) {
                      return GestureDetector(
                        child: Container(
                            width: constraints.biggest.width,
                            child: Text(
                              "${productManager.search}",
                              textAlign: TextAlign.center,
                            )),
                        onTap: () async {
                          final search = await showDialog<String>(
                              context: context,
                              builder: (_) => SearchDialog(
                                    initialText: productManager.search,
                                  ));
                          if (search != null) productManager.search = search;
                        },
                      );
                    },
                  );
          },
        ),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(
                product: filteredProducts[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
