import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:customers/src/pages/form-resume-page.dart';
import 'package:flutter/material.dart';

class QRReaderPage extends StatefulWidget {
  static final String routeName = 'qrreader';

  @override
  _QRReaderPageState createState() => _QRReaderPageState();
}

class _QRReaderPageState extends State<QRReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lectura de Codigo QR'),
        ),
        body: Center(
            child: Container(
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Aca puedes leer el codigo QR de tu visitante para obtener la información de su entrevista COVID-19',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
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
        )));
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
    Navigator.pushNamed(context, FormResumePage.routeName, arguments: qrInfo);
  }
}
