import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/branchs-page.dart';
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
import 'package:customers/src/pages/terms-page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:flutter/material.dart';
import 'package:customers/src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _prefs = PreferenceAuth();
  _prefs.initPrefs();
  await getInitialRoute();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = PreferenceAuth();
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clientes Comercio',
        theme: ThemeData(
          primaryColor: Color(0xff002d6a),
          secondaryHeaderColor: Color(0xff00a461),
        ),
        initialRoute: _prefs.initialRoute,
        routes: {
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
          FormPage.routeName: (BuildContext context) => FormPage(),
          FormList.routeName: (BuildContext context) => FormList(),
          FormDetail.routeName: (BuildContext context) => FormDetail(),
          ShopForm.routeName: (BuildContext context) => ShopForm(),
          BranchPage.routeName: (BuildContext context) => BranchPage(),
          FormResumePage.routeName: (BuildContext context) => FormResumePage(),
          SignaturePage.routeName: (BuildContext context) => SignaturePage(),
          QRCodePage.routeName: (BuildContext context) => QRCodePage(),
          QRReaderPage.routeName: (BuildContext context) => QRReaderPage(),
          TermsPage.routeName: (BuildContext context) => TermsPage()
        },
      ),
    );
  }
}
