import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/shop.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/pages/branchs-page.dart';
import 'package:customers/src/pages/form-list-page.dart';
import 'package:customers/src/pages/form-resume-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/shop-form.page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/services/login.service.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRReaderPage extends StatefulWidget {
  static final String routeName = 'qrreader';

  @override
  _QRReaderPageState createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  ShopBloc _shopBloc;
  final LoginService logSrvc = new LoginService();
  int _cIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();
    _shopBloc = Provider.shopBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lectura QR'),
        actions: [
          Row(
            children: [
              Text('Salir'),
              SizedBox(
                width: 5,
              ),
              IconButton(
                  icon: Icon(Icons.input), onPressed: () => _logOut(context)),
            ],
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0),
                colors: [
                  const Color(0xffa4b9f3),
                  const Color(0xFF000000)
                ], // whitish to gray
                tileMode:
                    TileMode.mirror, // repeats the gradient over the canvas
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<String>(
                    stream: _shopBloc.shopNameStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');
                      return Text(
                        'Bienvenido ${capitalizeWord(snapshot.data)}',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      );
                    }),
                Divider(
                  height: 50,
                  color: Theme.of(context).secondaryHeaderColor,
                  indent: 30,
                  endIndent: 30,
                  thickness: 3,
                ),
                StreamBuilder<ShopBranchModel>(
                    stream: _shopBloc.shopCurrBranchStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        if (!snapshot.hasData) {
                          if (_prefs.currentBranch.branchDocumentId != null) {
                            _shopBloc.changeShopCurrBranch(_prefs.currentBranch);
                          }
                          return Text('Sucursal: Seleccione sucursal',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white));
                        }
                      }
                      return Text(
                        'Sucursal: ${capitalizeWord(snapshot.data.branchName)}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      );
                    }),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Aca puedes leer el codigo QR de tu visitante para obtener la información de su encuesta',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 50,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: EdgeInsets.all(20),
                    color: Theme.of(context).secondaryHeaderColor,
                    textColor: Colors.white,
                    onPressed: () => _getQRinfo(context, _shopBloc),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Leer Código QR',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.filter_center_focus,
                          size: 30,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cIndex,
        onTap: (index) => goTo(index, _shopBloc),
        items: [
          BottomNavigationBarItem(
              title: Text('Editar Comercio'),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).secondaryHeaderColor,
                size: 22,
              )),
          BottomNavigationBarItem(
            title: Text('Ver Encuestas'),
            icon: Icon(
              Icons.list,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Sucursales'),
            icon: Icon(
              Icons.shop_two,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ],
      ),
    );
  }

  _getQRinfo(BuildContext context, ShopBloc bloc) async {
    if (bloc.shopCurrBranch == null) {
      Fluttertoast.showToast(
        msg: 'Debe seleccionar una sucursal!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      ).then((value) => Navigator.of(context).pushNamed(BranchPage.routeName));
    } else {
      logSrvc.isStateOkByBloc(context).then((value) async {
        if (value) {
          String qrInfo = '';
          try {
            qrInfo = await BarcodeScanner.scan();
          } catch (e) {
            qrInfo = e.toString();
          }
          Platform.isIOS
              ? Future.delayed(
                  Duration(milliseconds: 750), () => goToEnterviewInfo(qrInfo))
              : goToEnterviewInfo(qrInfo);
        } else {
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
        }
      });
    }
  }

  goToEnterviewInfo(String qrInfo) {
    if (qrInfo != 'FormatException: Invalid envelope') {
      Navigator.pushNamed(context, FormResumePage.routeName, arguments: qrInfo);
    }
  }

  void goTo(int index, ShopBloc bloc) {
    if (index == 1 && bloc.shopCurrBranch == null) {
      Fluttertoast.showToast(
        msg: 'Debe seleccionar una sucursal',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      return;
    }
    switch (index) {
      case 0:
        bloc.changeShopIsEditing(true);
        Navigator.of(context).pushNamed(ShopForm.routeName);
        break;
      case 1:
        Navigator.of(context).pushNamed(FormList.routeName);
        break;
      case 2:
        Navigator.of(context).pushNamed(BranchPage.routeName);
        break;
      default:
    }
  }

  void _logOut(BuildContext context) {
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();
    _prefs.isShopLoggedIn = false;
    _shopBloc.changeShopIsLogged(false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }
}
