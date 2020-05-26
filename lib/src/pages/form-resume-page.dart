import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/form.model.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
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
    String args = ModalRoute.of(context).settings.arguments;
    Map<String, dynamic> _formDataMap;
    try {
      _formDataMap = jsonDecode(args);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al leer código, intente de nuevo!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      Navigator.of(context).pop();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Datos Encuesta'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                UserFirebaseProvider.fb.getUserInfo(_formDataMap, context),
                _getFormField(getQuestion(1), _formDataMap['yourSymptoms'], 1,
                    memo: _formDataMap['yourSymptomsDesc']),
                _getFormField(
                    getQuestion(2), _formDataMap['yourHomeSymptoms'], 1),
                _getFormField(
                    getQuestion(3), _formDataMap['haveBeenIsolated'], 0,
                    memo: _formDataMap['haveBeenIsolatedDesc']),
                _getFormField(
                    getQuestion(4), _formDataMap['haveBeenVisited'], 1,
                    memo: _formDataMap['haveBeenVisitedDesc']),
                _getFormField(
                  getQuestion(5),
                  _formDataMap['haveBeenWithPeople'],
                  1,
                ),
                _getFormField(getQuestion(6), _formDataMap['visitorAccept'], 0),
                Visibility(
                  visible: _formDataMap['isEmployee'] == 1 ? true : false,
                  child: Column(
                    children: <Widget>[
                      _getFormField(getQuestion(7),
                          _formDataMap['employeeAcceptYourSymptoms'], 0),
                      _getFormField(getQuestion(8),
                          _formDataMap['employeeAcceptHomeSymptoms'], 0),
                      _getFormField(getQuestion(9),
                          _formDataMap['employeeAcceptVacationSymptoms'], 0),
                    ],
                  ),
                ),
                _createTemperatureField(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.all(15),
                        textColor: Colors.white,
                        child: Text(
                          'Registrar Ingreso',
                          style: TextStyle(fontSize: 15),
                        ),
                        color: Theme.of(context).secondaryHeaderColor,
                        onPressed: () =>
                            _saveDataToFirebase(_formDataMap, true),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(15),
                        textColor: Colors.white,
                        child: Text(
                          'Registrar Salida',
                          style: TextStyle(fontSize: 15),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () =>
                            _saveDataToFirebase(_formDataMap, false),
                      ),
                    ],
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
                  onChanged: (value) => setState(() {
                    _temperature = value;
                    final currentTemp = value == 'mas de 41°'
                        ? 42.0
                        : double.parse(value.replaceFirst('°', ''));
                    if (currentTemp >= 37) {
                      Fluttertoast.showToast(
                        msg: currentTemp > 38
                            ? "Fiebre Detectada!"
                            : "Temperatura peligrosa!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor:
                            currentTemp > 38 ? Colors.red : Colors.orange,
                        textColor: Colors.white,
                        fontSize: 18.0,
                      );
                    }
                  }),
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

  _saveDataToFirebase(formDataMap, bool isGettingIn) async {
    final UserBloc bloc = Provider.of(context);
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

    try {
      final FormModel form = FormModel(
        yourSymptoms: formDataMap['yourSymptoms'],
        yourSymptomsDesc: formDataMap['yourSymptomsDesc'],
        yourHomeSymptoms: formDataMap['yourHomeSymptoms'],
        haveBeenIsolated: formDataMap['haveBeenIsolated'],
        haveBeenIsolatedDesc: formDataMap['haveBeenIsolatedDesc'],
        haveBeenVisited: formDataMap['haveBeenVisited'],
        haveBeenVisitedDesc: formDataMap['haveBeenVisitedDesc'],
        haveBeenWithPeople: formDataMap['haveBeenWithPeople'],
        isEmployee: formDataMap['isEmployee'],
        visitorAccept: formDataMap['visitorAccept'],
        employeeAcceptYourSymptoms: formDataMap['employeeAcceptYourSymptoms'],
        employeeAcceptHomeSymptoms: formDataMap['employeeAcceptHomeSymptoms'],
        employeeAcceptVacationSymptoms:
            formDataMap['employeeAcceptVacationSymptoms'],
        lastDate: formDataMap['lastDate'],
        userDocumentId: formDataMap['userDocumentId'],
      );

      // INSERT FORM
      form.shopDocumentId = bloc.shopDocumentId;
      form.shopBranchDocumentId = bloc.shopCurrBranch.branchDocumentId;
      final formJson = form.toJson();
      formJson["temperature"] = _temperature;
      formJson["insertDate"] = DateTime.now();
      formJson["gettingIn"] = isGettingIn;
      _updateCapacity(bloc, isGettingIn);
      final user = UserModel(
          identificationType: formDataMap['identificationType'],
          identification: formDataMap['identification'],
          name: formDataMap['name'],
          lastName: formDataMap['lastName'],
          contact: formDataMap['contact'],
          email: formDataMap['email']);
      formJson.addAll(user.toJson());
      await Firestore.instance.collection('Forms').add(formJson);

      Fluttertoast.showToast(
        msg: "Encuesta registrada!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      ).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
          QRReaderPage.routeName, (Route<dynamic> route) => false));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _updateCapacity(UserBloc bloc, bool isGettingIn) async {
      var currCapacity = await ShopFirebaseProvider.fb.getBranchCapacity(bloc.shopCurrBranch.branchDocumentId);
      isGettingIn ? ++currCapacity : --currCapacity;
      var currentBranch = bloc.shopCurrBranch;
      currentBranch.capacity = currCapacity;
      bloc.changeShopCurrBranch(currentBranch);      
      ShopFirebaseProvider.fb.updateBranchCapacity(isGettingIn, currentBranch);
      // ShopDBProvider.db.updateShopBranch(currBranch);
  }
}
