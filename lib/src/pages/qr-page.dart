import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  static final String routeName = 'qr';
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Código QR'),
      ),
      body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text(
                'Presenta este codigo QR en los establecimientos que visites, de esta manera se puedra cargar toda la información de tu entrevista COVID-19!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  color: Colors.grey[50],
                  // child: Image.memory(image)
                  child: QrImage(
                    foregroundColor: Colors.purple[900],
                    data: args.toString(),
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width * .9,
                    errorStateBuilder: (cxt, err) {
                      return Container(
                        child: Center(
                          child: Text(
                            "Oops! ${err.toString()}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  )),
            ],
          )),
    );
  }
}
