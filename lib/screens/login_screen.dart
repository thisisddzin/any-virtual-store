import 'package:any_virtual_store/models/user_model.dart';
import 'package:any_virtual_store/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'CRIAR CONTA',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignupScreen())
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          else
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail'
                    ),
                    validator: (text) {
                      if(text.isEmpty || !text.contains('@')) return 'E-mail invalido!';
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                    ),
                    obscureText: true,
                    validator: (text) {
                      if(text.isEmpty || text.length < 6) return 'Senha Invalida!';
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text('Esqueci minha senha', textAlign: TextAlign.right,),
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        if(_emailController.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: 
                              Text(
                                'Insira seu em-mail para recuperar!'
                              ), 
                              backgroundColor: Colors.redAccent, 
                              duration: Duration(seconds: 2)
                            ),
                          );
                        } else {
                          model.recoverPass(email: _emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: 
                              Text(
                                'Confira seu e-mail!'
                              ), 
                              backgroundColor: Colors.blueAccent, 
                              duration: Duration(seconds: 2)
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          model.signIn(
                            email: _emailController.text, 
                            pass: _passController.text,
                            onFail: _onFail,
                            onSuccess: _onSuccess
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: 
        Text(
          'Erro ao entrar!'
        ), 
        backgroundColor: Colors.redAccent, 
        duration: Duration(seconds: 2)
      ),
    );
  }
}