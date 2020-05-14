import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:flutter/material.dart';

class FormDetail extends StatelessWidget {
  static final String routeName = 'formdetail';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> formDataMap =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getUserInfo(formDataMap, context),
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
            _getExport(context, formDataMap),
          ],
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
            'Teléfono: ${user['contact']}',
            style: textStyle,
          ),
          Text(
            'Email: ${user['email']}',
            style: textStyle,
          ),
          Text(
            'Temperatura: ${user['temperature']}',
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

  Container _getExport(BuildContext context, Map<String, dynamic> formDataMap) {
    return Container(
      child: RaisedButton(
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20),
        color: Theme.of(context).secondaryHeaderColor,
        onPressed: () => _downloadPDF(formDataMap),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Exportar a PDF',
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.file_download)
          ],
        ),
      ),
    );
  }

  _downloadPDF(Map<String, dynamic> formDataMap) {
    // List<String> values = ['uno', 'dos', 'tres', 'cuatro'];
    // final pdf = pw.Document();
    // pdf.addPage(
    //   pw.Page(
    //     build: null
    //   ),
    // );
  }
}
