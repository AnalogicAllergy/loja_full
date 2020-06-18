import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserManager(),
        lazy: false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Loja',
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 4, 125, 141),
            scaffoldBackgroundColor: Color.fromARGB(255, 4, 125, 141),
            appBarTheme: AppBarTheme(elevation: 0),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/base',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/signup':
                return MaterialPageRoute(builder: (_) => SignUpScreen());
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginScreen());
              case '/base':
              default:
                return MaterialPageRoute(builder: (_) => BaseScreen());
            }
          },
        ));
  }
}
