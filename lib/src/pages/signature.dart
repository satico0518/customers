import 'dart:convert';

import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/form.model.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/qr-page.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:customers/src/providers/form.provider.dart';
import 'package:customers/src/providers/qr.shared-preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignaturePage extends StatefulWidget {
  static final String routeName = 'signature';

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Aceptación de Información'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: <Widget>[
              _createIsVisitor(bloc),
              SizedBox(
                height: 30,
              ),
              _createVisitor(bloc),
              StreamBuilder<int>(
                stream: bloc.isEmployeeStream,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: bloc.isEmployee == 1 ? true : false,
                    child: _createEmployee(bloc),
                  );
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                      onPressed: () => onFormSubmit(bloc)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIsVisitor(UserBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.isEmployeeStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Es usted empleado del sitio q visita?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: 1,
                      groupValue: bloc.isEmployee,
                      onChanged: bloc.changeIsEmployee,
                    ),
                    Text(
                      'Si',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: 0,
                      groupValue: bloc.isEmployee,
                      onChanged: bloc.changeIsEmployee,
                    ),
                    Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _createVisitor(UserBloc bloc) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            StreamBuilder<int>(
              stream: bloc.visitorAcceptStream,
              builder: (context, snapshot) {
                return CheckboxListTile(
                  activeColor: Theme.of(context).primaryColor,
                  value: bloc.visitorAccept == 1 ? true : false,
                  onChanged: (value) => bloc.changeVisitorAccept(value ? 1 : 0),
                  title: Text(
                    getQuestion(6),
                    textAlign: TextAlign.justify,
                  ),
                );
              }
            ),
          ],
        )
      ],
    );
  }

  Widget _createEmployee(UserBloc bloc) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            StreamBuilder<int>(
              stream: bloc.employeeAcceptYourSymptomsStream,
              builder: (context, snapshot) {
                return CheckboxListTile(
                  activeColor: Theme.of(context).primaryColor,
                  value: bloc.employeeAcceptYourSymptoms == 1 ? true : false,
                  onChanged: (value) =>
                      bloc.changeEmployeeAcceptYourSymptoms(value ? 1 : 0),
                  title: Text(
                    getQuestion(7),
                    textAlign: TextAlign.justify,
                  ),
                );
              }
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<int>(
              stream: bloc.employeeAcceptHomeSymptomsStream,
              builder: (context, snapshot) {
                return CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    value: bloc.employeeAcceptHomeSymptoms == 1 ? true : false,
                    onChanged: (value) =>
                        bloc.changeEmployeeAcceptHomeSymptoms(value ? 1 : 0),
                    title: Text(
                      getQuestion(8),
                      textAlign: TextAlign.justify,
                    ));
              }
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<int>(
              stream: bloc.employeeAcceptVacationSymptomsStream,
              builder: (context, snapshot) {
                return CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    value: bloc.employeeAcceptVacationSymptoms == 1 ? true : false,
                    onChanged: (value) =>
                        bloc.changeEmployeeAcceptVacationSymptoms(value ? 1 : 0),
                    title: Text(
                      getQuestion(9),
                      textAlign: TextAlign.justify,
                    ));
              }
            ),
          ],
        )
      ],
    );
  }

  onFormSubmit(UserBloc bloc) async {
    final String errorMessage = validateForm(bloc);
    if (errorMessage.isNotEmpty) {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    bloc.changeLastDate(new DateTime.now().toString().split('.')[0]);
    final form = new FormModel(
        yourSymptoms: bloc.yourSymptoms,
        yourHomeSymptoms: bloc.yourHomeSymptoms,
        haveBeenIsolated: bloc.haveBeenVisited,
        haveBeenVisited: bloc.haveBeenVisited,
        haveBeenWithPeople: bloc.haveBeenWithPeople,
        yourSymptomsDesc: bloc.yourSymptomsDesc,
        haveBeenIsolatedDesc: bloc.haveBeenIsolatedDesc,
        haveBeenVisitedDesc: bloc.haveBeenVisitedDesc,
        isEmployee: bloc.isEmployee,
        visitorAccept: bloc.visitorAccept,
        employeeAcceptYourSymptoms: bloc.employeeAcceptYourSymptoms,
        employeeAcceptHomeSymptoms: bloc.employeeAcceptHomeSymptoms,
        employeeAcceptVacationSymptoms: bloc.employeeAcceptVacationSymptoms,
        lastDate: bloc.lastDate);
    final user = new UserModel(
        id: 1,
        name: bloc.name,
        lastName: bloc.lastName,
        identificationType: bloc.identificationType,
        identification: bloc.identification,
        contact: bloc.contact,
        email: bloc.email);
    final formJson = form.toJson();
    formJson.addAll(user.toJson());
    await setQr(jsonEncode(formJson));
    DBProvider.db.deleteForm();
    DBProvider.db.addForm(form);
    Navigator.pushNamed(context, QRCodePage.routeName);
  }

  String validateForm(UserBloc bloc) {
    if (bloc.isEmployee == 1 &&
        (bloc.employeeAcceptYourSymptoms == 0 ||
            bloc.employeeAcceptHomeSymptoms == 0 ||
            bloc.employeeAcceptVacationSymptoms == 0)) {
      return 'debe aceptar las condiciones de empleado';
    } else if (bloc.visitorAccept == 0) {
      return 'Debe indicar que la informacion solicitada es verídica!';
    }
    return '';
  }
}
