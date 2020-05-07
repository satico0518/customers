import 'package:customers/src/drawer.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/register-page.dart';
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

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          label: Text('Ver mi QR', style: TextStyle(color: Theme.of(context).primaryColor),),
          icon: Icon(
            Icons.filter_center_focus,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () =>
              _goToQr(context, _scaffoldKey.currentState.showSnackBar),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Control COVID-19'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(
                    0.8, 0.0),
                colors: [
                  const Color(0xffa4b9f3),
                  const Color(0xFF000000)
                ], // whitish to gray
                tileMode:
                    TileMode.mirror, // repeats the gradient over the canvas
              ),
            ),
            width: screenSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/img/banner.jpg')),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Esta aplicacion te permite como visitante guardar tu entrevista COVID-19 y generar un codigo QR para que pueda ser leida toda tu informacion en los locales comerciales que visitas.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.dosis(fontSize: 20, color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, QRReaderPage.routeName),
                      child: _getContainer(
                          screenSize,
                          Icon(
                            Icons.business,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          'Ingresar como Comercio',
                          'Puedes scanear los codigos QR de tus visitantes para cargar todos los datos de su entrevista.'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RegisterPage.routeName),
                      child: _getContainer(
                          screenSize,
                          Icon(
                            Icons.people,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          'Ingresar como Persona',
                          'Puedes guardar tu información y los datos de la entevista para generar un código QR.'),
                    ),
                    SizedBox(
                      height: 20,
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

  Container _getContainer(dynamic screenSize, Icon icon, String text, String description) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
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
                style: TextStyle(
                    fontSize: 20, color: Colors.black87, fontFamily: 'Roboto'),
              ),
              icon,
            ],
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(description, textAlign: TextAlign.justify, style: TextStyle(fontSize: 15),))
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
}
