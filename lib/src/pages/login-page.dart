import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/register-page.dart';
import 'package:customers/src/pages/shop-form.page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customers/src/services/login.service.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginSrvc = LoginService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = '';
  String _password = '';
  bool _showPass = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .15,
                    ),
                    Text(
                      'PaseYa',
                      style: GoogleFonts.righteous(
                          letterSpacing: 5, fontSize: 55, color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: _userName,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Correo',
                                  icon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
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
                                initialValue: _password,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.bold),
                                obscureText: !_showPass,
                                decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    suffixIcon: IconButton(
                                        onPressed: () => setState(
                                            () => _showPass = !_showPass),
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ))),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Contraseña es obligatorio';
                                  return null;
                                },
                                onChanged: (value) =>
                                    setState(() => _password = value),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ButtonTheme(
                                child: Container(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RaisedButton(
                                        elevation: 10,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 100),
                                        textColor: Colors.white,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        child: Icon(
                                          Icons.input,
                                          size: 25,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        onPressed: () => _handleLogin(),
                                      ),
                                      Text(
                                        'V. 1.0.0',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (bloc.shopNit == null)
                              bloc.changeShopIsEditing(false);
                            else
                              bloc.changeShopIsEditing(true);
                            Navigator.of(context).pushNamed(ShopForm.routeName);
                          },
                          child: Text(
                            'Registrar Comercio',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (bloc.userDocumentId != null)
                              bloc.changeUserIsEditing(true);
                            else
                              bloc.changeUserIsEditing(false);
                            Navigator.of(context)
                                .pushNamed(RegisterPage.routeName);
                          },
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
              .getUserFirebaseByEmail(_userName.trim());
          if (userSnapshot.documents.length > 0) {
            final _prefs = PreferenceAuth();
            _prefs.initPrefs();
            if (userSnapshot.documents[0].data['type'] == 'CUSTOMER') {
              bloc.changeUserIsLogged(true);
              bloc.changeShopIsLogged(false);
              _prefs.isUserLoggedIn = true;
              _prefs.isShopLoggedIn = false;
              final userData =
                  UserModel.fromJson(userSnapshot.documents[0].data);
              bloc.changeUserIdType(userData.identificationType);
              bloc.changeUserIdentification(userData.identification);
              bloc.changeUserName(userData.name);
              bloc.changeUserGenre(userData.genre);
              bloc.changeUserBirthDate(userData.birthDate);
              bloc.changeUserLastName(userData.lastName);
              bloc.changeUserContact(userData.contact);
              bloc.changeUserAddress(userData.address);
              bloc.changeUserEmail(userData.email);
              bloc.changeUserPassword(userData.password);
              bloc.changeUserDocumentId(userData.documentId);
              bloc.changeUserFirebaseId(userData.firebaseId);
              UserDBProvider.db.deleteUser();
              UserDBProvider.db.addUser(userData);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (route) => false);
            } else {
              if (!user.isEmailVerified) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Inactivo!"),
                      content: Text(
                        "Debe revisar su correo electrónico para verificar el email suministrado en el registro.",
                        textAlign: TextAlign.justify,
                      ),
                      actions: <Widget>[
                        FlatButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              return;
                            }),
                      ],
                    );
                  },
                );
                UserFirebaseProvider.fb.sendEmailForVerification();
                return;
              }
              if (!loginSrvc.isStateOk(userSnapshot)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Inactivo!"),
                      content: Text(
                        "Ha caducado su periodo de prueba. Por favor contáctenos para poder ayudarle.",
                        textAlign: TextAlign.justify,
                      ),
                      actions: <Widget>[
                        FlatButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              return;
                            }),
                      ],
                    );
                  },
                );
                bloc.changeShopIsEditing(true);
              } else {
                bloc.changeUserIsLogged(false);
                bloc.changeShopIsLogged(true);
                _prefs.isUserLoggedIn = false;
                _prefs.isShopLoggedIn = true;
                ShopDBProvider.db
                    .saveShopIfNotExists(context, _userName.trim());
                if (bloc.shopCurrBranch == null) {
                  final DocumentSnapshot shopSnapshot =
                      await ShopFirebaseProvider.fb.getShopFirebase(
                          userSnapshot.documents[0].documentID);
                  bloc.changeShopDocumentId(shopSnapshot.documentID);
                  final QuerySnapshot branches = await ShopFirebaseProvider.fb
                      .getBranchesFbByShopDocId(shopSnapshot.documentID);
                  bloc.changeShopCurrBranch(ShopBranchModel.fromJson(branches.documents.first.data));
                  bloc.shopCurrBranch.branchDocumentId =
                      branches.documents[0].documentID;
                  _prefs.currentBranchDocId = branches.documents[0].documentID;
                } else
                  _prefs.currentBranchDocId =
                      bloc.shopCurrBranch.branchDocumentId;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    QRReaderPage.routeName, (route) => false);
              }
            }
          } else {
            throw ErrorDescription('Usuario no registrado!');
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
      return 'Error: $message';
  }
}
