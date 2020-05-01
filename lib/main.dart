import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/pages/signature.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clientes Comercio',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      initialRoute: FormPage.routeName,
      routes: {
        FormPage.routeName: (BuildContext context) => FormPage(),
        SignaturePage.routeName: (BuildContext context) => SignaturePage()
      }
    );
  }
}
