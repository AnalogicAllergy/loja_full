import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer/custom_drawer_header.dart';
import 'package:loja_virtual/common/drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color.fromARGB(205, 203, 236, 241),
              Colors.white
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(
                title: 'Inicio',
                page: 0,
                icon: Icons.home,
              ),
              DrawerTile(
                title: 'Produtos',
                page: 1,
                icon: Icons.list,
              ),
              DrawerTile(
                title: 'Meus pedidos',
                page: 2,
                icon: Icons.playlist_add_check,
              ),
              DrawerTile(
                title: 'Lojas',
                page: 3,
                icon: Icons.location_on,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
