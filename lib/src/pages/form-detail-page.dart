import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormDetail extends StatelessWidget {
  static final String routeName = 'formdetail';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final Map<String, dynamic> formDataMap =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
        actions: [
          Row(
            children: [
              Text('enviar email'),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendDetailEmail(context, formDataMap, bloc)),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            UserFirebaseProvider.fb.getUserInfo(formDataMap, context),
            _getFormField(getQuestion(1), formDataMap['yourSymptoms'],
                memo: formDataMap['yourSymptomsDesc']),
            _getFormField(getQuestion(2), formDataMap['yourHomeSymptoms']),
            _getFormField(getQuestion(3), formDataMap['haveBeenIsolated'],
                memo: formDataMap['haveBeenIsolatedDesc']),
            _getFormField(getQuestion(4), formDataMap['haveBeenVisited'],
                memo: formDataMap['haveBeenVisitedDesc']),
            _getFormField(
              getQuestion(5),
              formDataMap['haveBeenWithPeople'],
            ),
            _getFormField(getQuestion(6), formDataMap['visitorAccept']),
            Visibility(
              visible: formDataMap['isEmployee'] == 1 ? true : false,
              child: Column(
                children: <Widget>[
                  _getFormField(getQuestion(7),
                      formDataMap['employeeAcceptYourSymptoms']),
                  _getFormField(getQuestion(8),
                      formDataMap['employeeAcceptHomeSymptoms']),
                  _getFormField(getQuestion(9),
                      formDataMap['employeeAcceptVacationSymptoms']),
                ],
              ),
            ),
          ],
        ),
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
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Respuesta: ${field == 1 ? 'Si' : 'No'}'),
                  ],
                ),
              ),
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
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  _sendDetailEmail(BuildContext context, Map<String, dynamic> formDataMap,
      UserBloc bloc) async {
    final response = await sendSingleFormEmail(formDataMap, bloc);
    Fluttertoast.showToast(
      msg: response,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 18.0,
    ).then((value) => Navigator.of(context).pop());
  }
}
