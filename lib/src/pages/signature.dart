import 'package:customers/src/pages/qr-page.dart';
import 'package:customers/src/pages/signature-pad.dart';
import 'package:flutter/material.dart';

class SignaturePage extends StatefulWidget {
  static final String routeName = 'signature';

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  int _isEmployee = 0;
  int _visitorAccept = 0;
  int _employeeAcceptYourSymptoms = 0;
  int _employeeAcceptHomeSymptoms = 0;
  int _employeeAcceptVacationSymptoms = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Clase de visitante'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: <Widget>[
              _createIsVisitor(),
              SizedBox(
                height: 30,
              ),
              Visibility(visible: _isEmployee == 0 ? true : false, child: _createVisitor()),
              Visibility(visible: _isEmployee == 1 ? true : false, child: _createEmployee()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                      onPressed: () => onFormSubmit(args)),
                ],
              )            
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIsVisitor() {
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
                  groupValue: _isEmployee,
                  onChanged: (value) => setState(() => _isEmployee = value),
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
              activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: _isEmployee,
                  onChanged: (value) => setState(() => _isEmployee = value),
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
  }

  Widget _createVisitor() {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _visitorAccept == 1 ? true : false,
                onChanged: (value) => setState(() => _visitorAccept = value ? 1 : 0),
                title: Text(
                  'Declaro que la información que he suministrado en este cuestionario es verídica y que en caso de presentar alguno de los síntomas o de tener contacto con alguna persona contagiada con COVID-19, lo reportaré de manera inmediata al personal encargado.',
                  textAlign: TextAlign.justify,
                )),
          ],
        )
      ],
    );
  }

  Widget _createEmployee() {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _employeeAcceptYourSymptoms == 1 ? true : false,
                onChanged: (value) => setState(() => _employeeAcceptYourSymptoms = value ? 1 : 0),
                title: Text(
                  'Estoy de acuerdo en reportar, de manera inmediata, si presento alguno de los síntomas indicados en este documento.',
                  textAlign: TextAlign.justify,
                )
            ),
            SizedBox(height: 30,),
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _employeeAcceptHomeSymptoms == 1 ? true : false,
                onChanged: (value) => setState(() => _employeeAcceptHomeSymptoms = value ? 1 : 0),
                title: Text(
                  'Estoy de acuerdo en reportar, de manera inmediata, si en mi hogar hay una persona que presente los síntomas indicados en este documento.',
                  textAlign: TextAlign.justify,
                )
            ),
            SizedBox(height: 30,),
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _employeeAcceptVacationSymptoms == 1 ? true : false,
                onChanged: (value) => setState(() => _employeeAcceptVacationSymptoms = value ? 1 : 0),
                title: Text(
                  'Estoy de acuerdo en reportar, si durante una ausencia personal o durante mi periodo de vacaciones he presentado alguno de los síntomas.',
                  textAlign: TextAlign.justify,
                )
            ),
          ],
        )
      ],
    );
  }

  onFormSubmit(dynamic formArgs) {
    final args = {
      "isEmployee": _isEmployee,
      "visitorAccept": _visitorAccept,
      "employeeAcceptYourSymptoms": _employeeAcceptYourSymptoms,
      "employeeAcceptHomeSymptoms": _employeeAcceptHomeSymptoms,
      "employeeAcceptVacationSymptoms": _employeeAcceptVacationSymptoms,
      "signature": ''
    };
    print('args: $formArgs');
    args.addAll(formArgs);
    Navigator.pushNamed(context, QRCodePage.routeName, arguments: args);
  }
}