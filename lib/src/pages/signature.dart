import 'dart:convert';

import 'package:customers/src/bloc/form.bloc.dart';
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
    final _userBloc = Provider.of(context);
    final _formBloc = Provider.formBloc(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Aceptación de Información'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: <Widget>[
              _createIsVisitor(_formBloc),
              SizedBox(
                height: 30,
              ),
              _createVisitor(_formBloc),
              StreamBuilder<int>(
                  stream: _formBloc.isEmployeeStream,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: _formBloc.isEmployee == 1 ? true : false,
                      child: _createEmployee(_formBloc),
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                      onPressed: () => onFormSubmit(_formBloc, _userBloc)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIsVisitor(FormBloc bloc) {
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

  Widget _createVisitor(FormBloc bloc) {
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
                    onChanged: (value) =>
                        bloc.changeVisitorAccept(value ? 1 : 0),
                    title: Text(
                      getQuestion(6),
                      textAlign: TextAlign.justify,
                    ),
                  );
                }),
          ],
        )
      ],
    );
  }

  Widget _createEmployee(FormBloc bloc) {
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
                }),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<int>(
                stream: bloc.employeeAcceptHomeSymptomsStream,
                builder: (context, snapshot) {
                  return CheckboxListTile(
                      activeColor: Theme.of(context).primaryColor,
                      value:
                          bloc.employeeAcceptHomeSymptoms == 1 ? true : false,
                      onChanged: (value) =>
                          bloc.changeEmployeeAcceptHomeSymptoms(value ? 1 : 0),
                      title: Text(
                        getQuestion(8),
                        textAlign: TextAlign.justify,
                      ));
                }),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<int>(
                stream: bloc.employeeAcceptVacationSymptomsStream,
                builder: (context, snapshot) {
                  return CheckboxListTile(
                      activeColor: Theme.of(context).primaryColor,
                      value: bloc.employeeAcceptVacationSymptoms == 1
                          ? true
                          : false,
                      onChanged: (value) => bloc
                          .changeEmployeeAcceptVacationSymptoms(value ? 1 : 0),
                      title: Text(
                        getQuestion(9),
                        textAlign: TextAlign.justify,
                      ));
                }),
          ],
        )
      ],
    );
  }

  onFormSubmit(FormBloc bloc, UserBloc _userBloc) async {
    try {
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
        haveBeenIsolated: bloc.haveBeenIsolated,
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
        lastDate: bloc.lastDate,
        userDocumentId: _userBloc.userDocumentId,
      );
      final user = new UserModel(
        name: _userBloc.userName,
        lastName: _userBloc.lastName,
        identificationType: _userBloc.identificationType,
        identification: _userBloc.identification,
        contact: _userBloc.contact,
        email: _userBloc.email,
        birthDate: _userBloc.userBirthDate ?? DateTime(DateTime.now().year - 10),
      );      
      final formJson = form.toJson();
      formJson.addAll(user.toJson());
      formJson['birthDate'] = formJson['birthDate'].toString();
      formJson['maxDate'] = null;
      await setQr(jsonEncode(formJson));
      DBProvider.db.deleteForm();
      DBProvider.db.addForm(form);
      Navigator.pushNamed(context, QRCodePage.routeName);
    } catch (e) {
      print('Error guardo QR: ${e.toString()}');
    }
  }

  String validateForm(FormBloc bloc) {
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
