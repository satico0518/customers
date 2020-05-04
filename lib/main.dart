import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/qr-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/signature-pad.dart';
import 'package:customers/src/pages/signature.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clientes Comercio',
          theme: ThemeData(
            primaryColor: Color(0xff002d6a),
            secondaryHeaderColor: Color(0xff00a461)
          ),
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (BuildContext context) => HomePage(),
            FormPage.routeName: (BuildContext context) => FormPage(),
            SignaturePage.routeName: (BuildContext context) => SignaturePage(),
            QRCodePage.routeName: (BuildContext context) => QRCodePage(),
            QRReaderPage.routeName: (BuildContext context) => QRReaderPage(),
            Signature.routeName: (BuildContext context) => Signature(controller: new SignatureController())
          }),
    );
  }
}
