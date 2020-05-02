import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-page.dart';
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
            primaryColor: Colors.purple,
          ),
          initialRoute: FormPage.routeName,
          routes: {
            FormPage.routeName: (BuildContext context) => FormPage(),
            SignaturePage.routeName: (BuildContext context) => SignaturePage(),
            Signature.routeName: (BuildContext context) =>
                Signature(controller: new SignatureController())
          }),
    );
  }
}
