import 'dart:convert';
import 'dart:ui';

import 'package:customers/src/pages/signature-pad.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:flutter/material.dart';

class FormResumePage extends StatelessWidget {
  static final String routeName = 'formresume';
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
                _getFormField(getQuestion(1), formDataMap['yourSymptoms'],
                    memo: formDataMap['yourSymptomsDesc']),
                _getFormField(getQuestion(2), formDataMap['yourHomeSymptoms']),
                _getFormField(getQuestion(3), formDataMap['haveBeenIsolated'],
                    memo: formDataMap['haveBeenIsolatedDesc']),
                _getFormField(getQuestion(4), formDataMap['haveBeenVisited'],
                    memo: formDataMap['haveBeenVisitedDesc']),
                _getFormField(getQuestion(5), formDataMap['haveBeenWithPeople']),
                Visibility(
                    visible: formDataMap['isEmployee'] == '1' ? true : false,
                    child: _getFormField(
                        getQuestion(6), formDataMap['visitorAccept'])),
                Visibility(
                    visible: formDataMap['isEmployee'] == '0' ? true : false,
                    child: Column(
                      children: <Widget>[
                        _getFormField(getQuestion(7),
                            formDataMap['employeeAcceptYourSymptoms']),
                        _getFormField(getQuestion(8),
                            formDataMap['employeeAcceptHomeSymptoms']),
                        _getFormField(getQuestion(9),
                            formDataMap['employeeAcceptVacationSymptoms']),
                      ],
                    )),
                RaisedButton(
                    padding: EdgeInsets.all(15),
                    textColor: Colors.white,
                    child: Text(
                      'Firmar',
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () =>
                        Navigator.pushNamed(context, Signature.routeName)),
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Identificación: ${user['identificationType']} ${user['identification']}',
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

  Column _getFormField(String question, dynamic field, {String memo = ""}) {
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
                  color: Colors.greenAccent,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('Respuesta: ${field == '1' ? 'Si' : 'No'}'),
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
}
