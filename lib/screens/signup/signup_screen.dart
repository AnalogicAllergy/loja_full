import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  User user = new User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
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
              builder: (_, userManager, __) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Nome Completo"),
                      enabled: !userManager.loading,
                      autocorrect: false,
                      onSaved: (name) => user.name = name,
                      validator: (name) {
                        if (name.isEmpty)
                          return "Campo obrigatorio";
                        else if (name.length < 2)
                          return "Nome muito curto";
                        else if (name.trim().split(' ').length == 1)
                          return "Preencha seu nome completo";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !userManager.loading,
                      onSaved: (email) => user.email = email,
                      validator: (email) {
                        if (email.isEmpty)
                          return "Campo Obrigatorio";
                        else if (!emailValid(email)) return "Email invalido";
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
                      onSaved: (password) => user.password = password,
                      obscureText: true,
                      validator: (password) {
                        if (password.isEmpty)
                          return "Campo obrigatorio";
                        else if (password.length < 6)
                          return "Senha muito curta";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Repita a senha"),
                      autocorrect: false,
                      enabled: !userManager.loading,
                      obscureText: true,
                      onSaved: (confirm) => user.confirmedPassword = confirm,
                      validator: (password) {
                        if (password.isEmpty)
                          return "Campo obrigatorio";
                        else if (password.length < 6)
                          return "Senha muito curta";
                        return null;
                      },
                    ),
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
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();

                                  if (user.password != user.confirmedPassword) {
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("As senhas devem ser iguais"),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }
                                  userManager.signUp(
                                      user: user,
                                      onFail: (e) {
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Falha ao criar conta $e"),
                                          backgroundColor: Colors.red,
                                        ));
                                      },
                                      onSuccess: () {
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
                                "Criar Conta",
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
