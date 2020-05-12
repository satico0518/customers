import 'dart:convert';
import 'dart:ui';

import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormResumePage extends StatefulWidget {
  static final String routeName = 'formresume';

  @override
  _FormResumePageState createState() => _FormResumePageState();
}

class _FormResumePageState extends State<FormResumePage> {
  final List<String> _temperatureRange = [
    '',
    '35°',
    '35.5°',
    '36°',
    '36.5°',
    '37°',
    '37.5°',
    '38°',
    '38.5°',
    '39°',
    '39.5°',
    '40°',
    '40.5°',
    '41°',
    'mas de 41°'
  ];

  String _temperature = '';

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    final Map<String, dynamic> formDataMap = jsonDecode(args);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Datos Entrevista'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                _getUserInfo(formDataMap, context),
                _getFormField(getQuestion(1), formDataMap['yourSymptoms'], 1,
                    memo: formDataMap['yourSymptomsDesc']),
                _getFormField(
                    getQuestion(2), formDataMap['yourHomeSymptoms'], 1),
                _getFormField(
                    getQuestion(3), formDataMap['haveBeenIsolated'], 0,
                    memo: formDataMap['haveBeenIsolatedDesc']),
                _getFormField(getQuestion(4), formDataMap['haveBeenVisited'], 1,
                    memo: formDataMap['haveBeenVisitedDesc']),
                _getFormField(
                  getQuestion(5),
                  formDataMap['haveBeenWithPeople'],
                  1,
                ),
                _getFormField(
                    getQuestion(6), formDataMap['visitorAccept'], 0),
                Visibility(
                  visible: formDataMap['isEmployee'] == 1 ? true : false,
                  child: Column(
                    children: <Widget>[
                      _getFormField(getQuestion(7),
                          formDataMap['employeeAcceptYourSymptoms'], 0),
                      _getFormField(getQuestion(8),
                          formDataMap['employeeAcceptHomeSymptoms'], 0),
                      _getFormField(getQuestion(9),
                          formDataMap['employeeAcceptVacationSymptoms'], 0),
                    ],
                  ),
                ),
                _createTemperatureField(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    textColor: Colors.white,
                    child: Text(
                      'Guardar Entrevista',
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_temperature.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Debe registrar la temperatura del visitante!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text("Operación exitosa!"),
                            content:
                                Text("La entrevista ha quedado registrada."),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomePage.routeName,
                                      (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _getUserInfo(Map<String, dynamic> user, BuildContext context) {
    final textStyle = TextStyle(fontSize: 18, color: Colors.white);
    _returnIdTypeCode(String text) {
      String code = 'CC';
      switch (text) {
        case 'Cedula Ciudadanía':
          code = 'CC';
          break;
        case 'NIT':
          code = 'NIT';
          break;
        case 'Cedula Extrangería':
          code = 'CE';
          break;
        case 'Registro Civil':
          code = 'RC';
          break;
        case 'Otro':
          code = 'Otro';
          break;
        default:
          code = 'N/A';
      }
      return code;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Identificación: ${_returnIdTypeCode(user['identificationType'])} ${user['identification']}',
            style: textStyle,
          ),
          Text(
            'Nombre: ${user['name']} ${user['lastName']}',
            style: textStyle,
          ),
          Text(
            'Telefono: ${user['contact']}',
            style: textStyle,
          ),
          Text(
            'Email: ${user['email']}',
            style: textStyle,
          ),
        ],
      ),
    );
  }

  Column _getFormField(String question, dynamic field, int warningResponse,
      {String memo = ""}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                question,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  color: warningResponse == field
                      ? Colors.orangeAccent
                      : Colors.greenAccent,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('Respuesta: ${field == 1 ? 'Si' : 'No'}'),
                    ],
                  )),
              Visibility(
                visible: memo.length > 0,
                child: Container(
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black87))),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text: 'Observación: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 15),
                          children: [
                            TextSpan(
                              text: memo,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ]),
                    )),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _createTemperatureField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            'Ingrese la temperatura actual del visitante',
            style: TextStyle(fontSize: 18),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.wb_incandescent,
                color: Colors.redAccent,
              ),
              SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<String>(
                  hint: Text('Temperatura actual'),
                  value: _temperature,
                  items: _getOptionsDropdownItems(),
                  onChanged: (value) => setState(() => _temperature = value),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getOptionsDropdownItems() {
    List<DropdownMenuItem<String>> list = new List();
    _temperatureRange.forEach((type) {
      DropdownMenuItem<String> tempItem = new DropdownMenuItem(
        child: Text(type),
        value: type,
      );
      list.add(tempItem);
    });
    return list;
  }
}
