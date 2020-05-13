import 'dart:async';
import 'dart:convert';

import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/providers/qr.shared-preferences.dart';
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
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Código QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text(
                'Presenta este código QR en los establecimientos que visites, de esta manera se podrá cargar toda la información de tu entrevista COVID-19!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                color: Colors.grey[50],
                // child: Image.memory(image)
                child: FutureBuilder<String>(
                  future: getDataToQR(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return QrImage(
                        foregroundColor: Theme.of(context).secondaryHeaderColor,
                        data: snapshot.data,
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
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text('generando código ...'),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              StreamBuilder<String>(
                stream: bloc.lastDateStream,
                builder: (context, snapshot) {
                  return Text('Última fecha de actualización: ${bloc.lastDate}.');
                }
              )
            ],
          )),
    );
  }

  Future<String> getDataToQR() async {
    final args = await getQr();
    final bloc = Provider.of(context);
    final Map<String, dynamic> userMap = {
      "identificationType": bloc.identificationType,
      "identification": bloc.identification,
      "name": bloc.userName,
      "lastName": bloc.lastName,
      "contact": bloc.contact,
      "email": bloc.email
    };
    var completer = new Completer<String>();
    final decodedata = jsonDecode(args);
    decodedata.addAll(userMap);
    final result = jsonEncode(decodedata);
    completer.complete(result);
    return completer.future;
  }
}
