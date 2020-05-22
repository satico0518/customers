import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/register-page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/providers/qr.shared-preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customers/src/pages/qr-page.dart';

class HomePage extends StatelessWidget {
  static final String routeName = 'home';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bloc = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          label: Text(
            'Ver mi QR',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          icon: Icon(
            Icons.filter_center_focus,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () =>
              _goToQr(context, _scaffoldKey.currentState.showSnackBar),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                  height: 20,
                ),
                Text(
                  'Control Aislamiento',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Esta aplicación te permite como visitante guardar tu encuesta de Salud y Distanciamiento Social y generar un código QR para que pueda ser leida toda tu información en los locales comerciales que visitas.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.abel(fontSize: 18, color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, FormPage.routeName),
                      child: _getContainer(
                        context,
                        screenSize,
                        Icon(
                          Icons.description,
                          size: 30,
                          color: Colors.white,
                        ),
                        'Diligenciar Encuesta',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        bloc.changeUserIsEditing(true);
                        Navigator.pushNamed(context, RegisterPage.routeName);
                      },
                      child: _getContainer(
                        context,
                        screenSize,
                        Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                        'Actualizar Usuario',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _getContainer(
      BuildContext context, dynamic screenSize, Icon icon, String text) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(3, 3))
          ]),
      width: screenSize.width - 50,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              icon,
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  void _goToQr(BuildContext context, showSnackBar) async {
    final qrData = await getQr();
    if (qrData.isEmpty) {
      final snackBar = SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          'No se ha generado un codigo QR!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
      showSnackBar(snackBar);
    } else {
      Navigator.pushNamed(context, QRCodePage.routeName);
    }
  }

  void _logOut(BuildContext context) {
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();
    _prefs.isUserLoggedIn = false;
    final bloc = Provider.of(context);
    bloc.changeUserIsLogged(false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }
}
