import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static final String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Entrevista COVID-19'),
        ),
        body: Container(
          width: screenSize.width,
          decoration:
              BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, QRReaderPage.routeName),
                child: _getContainer(
                    screenSize,
                    Icon(
                      Icons.business,
                      size: 150,
                      color: Theme.of(context).primaryColor,
                    ),
                    'Soy local comercial'),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, FormPage.routeName),
                              child: _getContainer(
                    screenSize,
                    Icon(
                      Icons.people,
                      size: 150,
                      color: Theme.of(context).primaryColor,
                    ),
                    'Soy Visitante'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _getContainer(dynamic screenSize, Icon icon, String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(3, 3))
          ]),
      height: (screenSize.height / 2) - 100,
      width: screenSize.width - 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Text(
            text,
            style: TextStyle(
                fontSize: 30, color: Colors.black87, fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }
}
