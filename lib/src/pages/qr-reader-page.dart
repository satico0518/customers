import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/pages/branchs-page.dart';
import 'package:customers/src/pages/form-list-page.dart';
import 'package:customers/src/pages/form-resume-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/shop-form.page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRReaderPage extends StatefulWidget {
  static final String routeName = 'qrreader';

  @override
  _QRReaderPageState createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  int _cIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();
    final bloc = Provider.of(context);
    ShopDBProvider.db
        .getShopBranchByDocId(_prefs.currentBranchDocId)
        .then((value) => bloc.changeShopCurrBranch(value));

    return Scaffold(
      appBar: AppBar(
        title: Text('Lectura de Codigo QR'),
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
                    stream: bloc.shopNameStream,
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
                    stream: bloc.shopCurrBranchStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Text('Sucursal: Seleccione sucursal',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white));
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
                    onPressed: _getQRinfo,
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
        onTap: (index) => goTo(index, bloc),
        items: [
          BottomNavigationBarItem(
              title: Text('Editar Tienda'),
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

  _getQRinfo() async {
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
  }

  goToEnterviewInfo(String qrInfo) {
    if (qrInfo != 'FormatException: Invalid envelope') {
      Navigator.pushNamed(context, FormResumePage.routeName, arguments: qrInfo);
    }
  }

  void goTo(int index, UserBloc bloc) {
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
    final bloc = Provider.of(context);
    bloc.changeShopIsLogged(false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }
}
