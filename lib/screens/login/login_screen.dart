import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            textColor: Colors.white,
            child: Text(
              "Criar conta",
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            //observable do tipo userManager
            child: Consumer<UserManager>(
              //(contexto, observable, child = pode ser __)
              builder: (_, userManager, child) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: _emailController,
                      validator: (email) {
                        if (!emailValid(email)) {
                          return "Por favor, insira um email valido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Senha"),
                      autocorrect: false,
                      enabled: !userManager.loading,
                      controller: _passwordController,
                      obscureText: true,
                      validator: (password) {
                        if (password.isEmpty || password.length < 6)
                          return "Senha invalida";
                        return null;
                      },
                    ),
                    child,
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        disabledColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            User user = new User(
                                email: _emailController.text,
                                password: _passwordController.text);
                            userManager.signIn(
                                user: user,
                                onFail: (e) {
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Falha ao entrar $e"),
                                    backgroundColor: Colors.red,
                                  ));
                                },
                                onSuccess: () {
                                  //TODO FECHAR TELA DE LOGIN
                                  Navigator.of(context).pop();
                                });
                          }
                        },
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                "Entrar",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    )
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: Text("Esqueci a senha"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
