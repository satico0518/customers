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
      appBar: AppBar(title: Text('leer codigo qr'),),
       body: Center(child: Text('qr reader'),),
    );
  }
}