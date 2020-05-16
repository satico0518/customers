import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/register-page.dart';
import 'package:customers/src/pages/shop-form.page.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    int _index = 0;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 40,
          currentIndex: _index,
          backgroundColor: Color.fromRGBO(255, 255, 255, .9),
          items: [
            BottomNavigationBarItem(
              title: Text(
                'Registro Persona',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(
                Icons.person,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                'Registro Comercio',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(
                Icons.store_mall_directory,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ],
          onTap: (index) {
            setState(() => _index = index);
            index == 0
                ? Navigator.of(context).pushNamed(RegisterPage.routeName)
                : Navigator.of(context).pushNamed(ShopForm.routeName);
          },
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 0.0),
              colors: [
                const Color(0xffa4b9f3),
                const Color(0xFF000000)
              ], // whitish to gray
              tileMode: TileMode.mirror, // repeats the gradient over the canvas
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/img/banner.jpg')),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
                  child: Divider(color: Colors.grey),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(255, 255, 255, .9),
                        ),
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Correo',
                                    hintText: 'correo@dominio.com',
                                    helperText: 'Ingrese el Correo',
                                    icon: Icon(Icons.mail_outline),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Correo es obligatorio';
                                  return null;
                                },
                                onChanged: (value) =>
                                    setState(() => _userName = value),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    helperText: 'Ingrese la Contraseña',
                                    icon: Icon(Icons.vpn_key),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Contraseña es obligatorio';
                                  return null;
                                },
                                onChanged: (value) =>
                                    setState(() => _password = value),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ButtonTheme(
                                minWidth: double.infinity,
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  textColor: Colors.white,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () => _handleLogin(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleLogin() async {
    final bloc = Provider.of(context);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final FirebaseUser user = await UserFirebaseProvider.fb
            .loginUserToFirebase(_userName.trim(), _password.trim());
        if (user.uid.isNotEmpty) {
          final QuerySnapshot userSnapshot = await UserFirebaseProvider.fb.getUserFirebaseByemail(_userName.trim());
          bloc.changeUserIsLogged(true);
          if (userSnapshot.documents[0].data['type'] == 'CUSTOMER') {
            Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          } else {
            ShopDBProvider.db.saveShopIfNotExists(context, _userName.trim());
            Navigator.of(context).pushNamedAndRemoveUntil(QRReaderPage.routeName, (route) => false);
          }
            
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: _handleErrorMessage(e.toString()),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      }
    }
  }

  String _handleErrorMessage(String message) {
    if (message.contains('ERROR_INVALID_EMAIL')) {
      return 'Correo inválido!';
    } else if (message.contains('ERROR_WRONG_PASSWORD')) {
      return 'Password inválido!';
    } else if (message.contains('ERROR_USER_NOT_FOUND')) {
      return 'Usuario no encontrado!';
    } else if (message.contains('ERROR_USER_DISABLED')) {
      return 'Usuario deshabilitado!';
    } else if (message.contains('ERROR_TOO_MANY_REQUESTS')) {
      return 'Demasiados intentos!';
    } else if (message.contains('ERROR_OPERATION_NOT_ALLOWED')) {
      return 'Operación no permitida!';
    } else
      return 'Error desconocido.';
  }
}
