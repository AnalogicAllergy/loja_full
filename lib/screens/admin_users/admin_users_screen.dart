import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer/custom_drawer.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Usuários'),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Consumer<AdminUsersManager>(
          builder: (_, adminUserManager, __) {
            return AlphabetListScrollView(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    adminUserManager.users[index].name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    adminUserManager.users[index].email,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              highlightTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              indexedHeight: (index) => 80,
              showPreview: true,
              strList: adminUserManager.names,
            );
          },
        ));
  }
}
