import 'package:customers/src/pages/signature.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  static final String routeName = 'form';

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int _yourSymptoms = 1;
  int _yourHomeSymptoms = 0;
  int _haveBeenIsolated = 1;
  int _haveBeenVisited = 0;
  int _haveBeenWithPeople = 0;
  String _yourSymptomsDesc = 'fiebre y tos';
  String _haveBeenIsolatedDesc = 'no quice';
  String _haveBeenVisitedDesc = 'muchass';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de verificación COVID-19'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Entrevista',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              Form(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  _createYourSymptoms(),
                  SizedBox(
                    height: 25,
                  ),
                  _createYourHomeSymptoms(),
                  SizedBox(
                    height: 25,
                  ),
                  _createIsolate(),
                  SizedBox(
                    height: 25,
                  ),
                  _createVisits(),
                  SizedBox(
                    height: 25,
                  ),
                  _createWithPeople(),
                  SizedBox(
                    height: 25,
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                      onPressed: () => onSubmitForm()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createYourSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '1. Presenta sintomas de gripe como fiebre, tos, falta de aire, o dificultad para respirar?',
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
              groupValue: _yourSymptoms,
              onChanged: (value) => setState(() => _yourSymptoms = value),
            ),
            Text(
              'Si',
              style: TextStyle(fontSize: 16.0),
            ),
            Radio(
              activeColor: Theme.of(context).primaryColor,
              value: 0,
              groupValue: _yourSymptoms,
              onChanged: (value) => setState(() => _yourSymptoms = value),
            ),
            Text(
              'No',
              style: TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
            visible: _yourSymptoms == 1 ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Describa cual de los sintomas presentó'),
                TextFormField(
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'minimo 5 caracteres';
                    } else {
                      return null;
                    }
                  },
                  initialValue: _yourSymptomsDesc,
                  onChanged: (value) =>
                      setState(() => _yourSymptomsDesc = value),
                )
              ],
            ))
      ],
    );
  }

  Widget _createYourHomeSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              '2. En su casahay alguna persona que presente estos síntomas?',
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
                  groupValue: _yourHomeSymptoms,
                  onChanged: (value) =>
                      setState(() => _yourHomeSymptoms = value),
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: _yourHomeSymptoms,
                  onChanged: (value) =>
                      setState(() => _yourHomeSymptoms = value),
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

  Widget _createIsolate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '3. Ha permanecido en aislamiento preventivo?',
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
              groupValue: _haveBeenIsolated,
              onChanged: (value) => setState(() => _haveBeenIsolated = value),
            ),
            Text(
              'Si',
              style: TextStyle(fontSize: 16.0),
            ),
            Radio(
              activeColor: Theme.of(context).primaryColor,
              value: 0,
              groupValue: _haveBeenIsolated,
              onChanged: (value) => setState(() => _haveBeenIsolated = value),
            ),
            Text(
              'No',
              style: TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
            visible: _haveBeenIsolated == 0 ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Indique el motivo'),
                TextFormField(
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'minimo 5 caracteres';
                    } else {
                      return null;
                    }
                  },
                  initialValue: _haveBeenIsolatedDesc,
                  onChanged: (value) =>
                      setState(() => _haveBeenIsolatedDesc = value),
                )
              ],
            ))
      ],
    );
  }

  Widget _createVisits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '4. Ha realizado visitas a familiares o amigos durante los ultimos 8 dias?',
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
              groupValue: _haveBeenVisited,
              onChanged: (value) => setState(() => _haveBeenVisited = value),
            ),
            Text(
              'Si',
              style: TextStyle(fontSize: 16.0),
            ),
            Radio(
              activeColor: Theme.of(context).primaryColor,
              value: 0,
              groupValue: _haveBeenVisited,
              onChanged: (value) => setState(() => _haveBeenVisited = value),
            ),
            Text(
              'No',
              style: TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
            visible: _haveBeenVisited == 1 ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Describa a quien y por que?'),
                TextFormField(
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'minimo 5 caracteres';
                    } else {
                      return null;
                    }
                  },
                  initialValue: _haveBeenVisitedDesc,
                  onChanged: (value) =>
                      setState(() => _haveBeenVisitedDesc = value),
                )
              ],
            ))
      ],
    );
  }

  Widget _createWithPeople() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              '5. Ha estado en contacto con mas de 10 personas en un mismo lugar, en los ultimos 8 dias? Ej: Transporte publico, parque , reunion social, etc',
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
                  groupValue: _haveBeenWithPeople,
                  onChanged: (value) =>
                      setState(() => _haveBeenWithPeople = value),
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: _haveBeenWithPeople,
                  onChanged: (value) =>
                      setState(() => _haveBeenWithPeople = value),
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

  onSubmitForm() {
    final form = {
      'yourSymptoms': _yourSymptoms,
      'yourHomeSymptoms': _yourHomeSymptoms,
      'haveBeenIsolated': _haveBeenIsolated,
      'haveBeenVisited': _haveBeenVisited,
      'haveBeenWithPeople': _haveBeenWithPeople,
      'yourSymptomsDesc': _yourSymptomsDesc,
      'haveBeenIsolatedDesc': _haveBeenIsolatedDesc,
      'haveBeenVisitedDesc': _haveBeenVisitedDesc
    };
    // formBloc.changeYourSymptoms(_yourSymptoms);
    // formBloc.changeYourSymptomsDesc(_yourSymptomsDesc);
    // formBloc.changeYourHomeSymptoms(_yourHomeSymptoms);
    // formBloc.changeHaveBeenIsolated(_haveBeenIsolated);
    // formBloc.changeHaveBeenIsolatedDesc(_haveBeenIsolatedDesc);
    // formBloc.changeHaveBeenVisited(_haveBeenVisited);
    // formBloc.changeHaveBeenVisitedDesc(_haveBeenVisitedDesc);
    // formBloc.changeHaveBeenWithPeople(_haveBeenWithPeople);
    Navigator.pushNamed(context, SignaturePage.routeName, arguments: form);
  }
}
