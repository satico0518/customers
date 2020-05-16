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
import 'package:google_fonts/google_fonts.dart';

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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: .6,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/img/background.jpg')),
                  ),
                ),
                Opacity(
                  opacity: .8,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 0.0),
                        colors: [
                          const Color(0xffa4b9f3),
                          const Color(0xFF000000)
                        ], // whitish to gray
                        tileMode: TileMode
                            .mirror, // repeats the gradient over the canvas
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 150,),
                    Text(
                      'PaseYa',
                      style: GoogleFonts.righteous(
                          letterSpacing: 5, fontSize: 55, color: Colors.white),
                    ),
                    SizedBox(height: 70,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Correo',
                                  icon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                  ),
                                  labelStyle:
                                      TextStyle(color: Colors.white),
                                  
                                ),
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
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  icon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.white,
                                  ),
                                  labelStyle:
                                      TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Contraseña es obligatorio';
                                  return null;
                                },
                                onChanged: (value) =>
                                    setState(() => _password = value),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              ButtonTheme(
                                child: RaisedButton(
                                  elevation: 10,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 100),
                                  textColor: Colors.white,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor,
                                  child: Icon(Icons.input),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)),
                                  onPressed: () => _handleLogin(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(ShopForm.routeName),
                          child: Text(
                            'Registrar Comercio',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(RegisterPage.routeName),
                          child: Text(
                            'Registrar Persona',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
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
          final QuerySnapshot userSnapshot = await UserFirebaseProvider.fb
              .getUserFirebaseByemail(_userName.trim());
          bloc.changeUserIsLogged(true);
          if (userSnapshot.documents[0].data['type'] == 'CUSTOMER') {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          } else {
            ShopDBProvider.db.saveShopIfNotExists(context, _userName.trim());
            Navigator.of(context).pushNamedAndRemoveUntil(
                QRReaderPage.routeName, (route) => false);
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
