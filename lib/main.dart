import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-detail-page.dart';
import 'package:customers/src/pages/form-list-page.dart';
import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/pages/form-resume-page.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/qr-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/register-page.dart';
import 'package:customers/src/pages/shop-form.page.dart';
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
          secondaryHeaderColor: Color(0xff00a461),
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
          FormPage.routeName: (BuildContext context) => FormPage(),
          FormList.routeName: (BuildContext context) => FormList(),
          FormDetail.routeName: (BuildContext context) => FormDetail(),
          ShopForm.routeName: (BuildContext context) => ShopForm(),
          FormResumePage.routeName: (BuildContext context) => FormResumePage(),
          SignaturePage.routeName: (BuildContext context) => SignaturePage(),
          QRCodePage.routeName: (BuildContext context) => QRCodePage(),
          QRReaderPage.routeName: (BuildContext context) => QRReaderPage()
        },
      ),
    );
  }
}
