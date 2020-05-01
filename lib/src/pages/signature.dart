import 'package:flutter/material.dart';

class SignaturePage extends StatefulWidget {
  static final String routeName = 'signature';

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  bool _isEmployee = false;
  bool _visitorAccept = false;
  bool _employeeAcceptYourSymptoms = false;
  bool _employeeAcceptHomeSymptoms = false;
  bool _employeeAcceptVacationSymptoms = false;

  @override
  Widget build(BuildContext context) {
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
              Visibility(visible: !_isEmployee, child: _createVisitor()),
              Visibility(visible: _isEmployee, child: _createEmployee()),              
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
                  value: true,
                  groupValue: _isEmployee,
                  onChanged: (value) => setState(() => _isEmployee = value),
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
              activeColor: Theme.of(context).primaryColor,
                  value: false,
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
                value: _visitorAccept,
                onChanged: (value) => setState(() => _visitorAccept = value),
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
                value: _employeeAcceptYourSymptoms,
                onChanged: (value) => setState(() => _employeeAcceptYourSymptoms = value),
                title: Text(
                  'Estoy de acuerdo en reportar, de manera inmediata, si presento alguno de los síntomas indicados en este documento.',
                  textAlign: TextAlign.justify,
                )
            ),
            SizedBox(height: 30,),
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _employeeAcceptHomeSymptoms,
                onChanged: (value) => setState(() => _employeeAcceptHomeSymptoms = value),
                title: Text(
                  'Estoy de acuerdo en reportar, de manera inmediata, si en mi hogar hay una persona que presente los síntomas indicados en este documento.',
                  textAlign: TextAlign.justify,
                )
            ),
            SizedBox(height: 30,),
            CheckboxListTile(
              activeColor: Theme.of(context).primaryColor,
                value: _employeeAcceptVacationSymptoms,
                onChanged: (value) => setState(() => _employeeAcceptVacationSymptoms = value),
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

}
