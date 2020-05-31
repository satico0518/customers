import 'package:customers/src/bloc/form.bloc.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/signature.dart';
import 'package:customers/src/providers/form-questions.provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormPage extends StatefulWidget {
  static final String routeName = 'form';

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    final _formBloc = Provider.formBloc(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: <Widget>[
              Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    _createYourSymptoms(_formBloc),
                    SizedBox(
                      height: 25,
                    ),
                    _createYourHomeSymptoms(_formBloc),
                    SizedBox(
                      height: 25,
                    ),
                    _createIsolate(_formBloc),
                    SizedBox(
                      height: 25,
                    ),
                    _createVisits(_formBloc),
                    SizedBox(
                      height: 25,
                    ),
                    _createWithPeople(_formBloc),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                      onPressed: () => onSubmitForm(_formBloc)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createYourSymptoms(FormBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.yourSymptomsStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getQuestion(1),
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
                  groupValue: bloc.yourSymptoms,
                  onChanged: bloc.changeYourSymptoms,
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: bloc.yourSymptoms,
                  onChanged: (value) {
                    bloc.changeYourSymptomsDesc('');
                    bloc.changeYourSymptoms(value);
                  },
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
              visible: bloc.yourSymptoms == 1 ? true : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Describa cual de los sintomas presentó'),
                  StreamBuilder<String>(
                    stream: bloc.yourSymptomsDescStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value.length < 5) {
                            return 'minimo 5 caracteres';
                          } else {
                            return null;
                          }
                        },
                        initialValue: bloc.yourSymptomsDesc,
                        onChanged: bloc.changeYourSymptomsDesc,
                      );
                    },
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _createYourHomeSymptoms(FormBloc bloc) {
    return StreamBuilder<int>(
        stream: bloc.yourHomeSymptomsStream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    getQuestion(2),
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
                        groupValue: bloc.yourHomeSymptoms,
                        onChanged: bloc.changeYourHomeSymptoms,
                      ),
                      Text(
                        'Si',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: 0,
                        groupValue: bloc.yourHomeSymptoms,
                        onChanged: bloc.changeYourHomeSymptoms,
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
        });
  }

  Widget _createIsolate(FormBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.haveBeenIsolatedStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getQuestion(3),
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
                  groupValue: bloc.haveBeenIsolated,
                  onChanged: (value) {
                    bloc.changeHaveBeenIsolatedDesc('');
                    bloc.changeHaveBeenIsolated(value);
                  },
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: bloc.haveBeenIsolated,
                  onChanged: bloc.changeHaveBeenIsolated,
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
              visible: bloc.haveBeenIsolated == 0 ? true : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Indique el motivo'),
                  StreamBuilder<String>(
                    stream: bloc.haveBeenIsolatedDescStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value.length < 5) {
                            return 'mínimo 5 caracteres';
                          } else {
                            return null;
                          }
                        },
                        initialValue: bloc.haveBeenIsolatedDesc,
                        onChanged: bloc.changeHaveBeenIsolatedDesc,
                      );
                    },
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _createVisits(FormBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.haveBeenVisitedStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getQuestion(4),
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
                  groupValue: bloc.haveBeenVisited,
                  onChanged: bloc.changeHaveBeenVisited,
                ),
                Text(
                  'Si',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: bloc.haveBeenVisited,
                  onChanged: (value) {
                    bloc.changeHaveBeenVisitedDesc('');
                    bloc.changeHaveBeenVisited(value);
                  },
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
              visible: bloc.haveBeenVisited == 1 ? true : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Describa a quien y por que?'),
                  StreamBuilder<String>(
                    stream: bloc.haveBeenVisitedDescStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.length < 5) {
                              return 'minimo 5 caracteres';
                            } else {
                              return null;
                            }
                          },
                          initialValue: bloc.haveBeenVisitedDesc,
                          onChanged: bloc.changeHaveBeenVisitedDesc);
                    },
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _createWithPeople(FormBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.haveBeenWithPeopleStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  getQuestion(5),
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
                      groupValue: bloc.haveBeenWithPeople,
                      onChanged: bloc.changeHaveBeenWithPeople,
                    ),
                    Text(
                      'Si',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: 0,
                      groupValue: bloc.haveBeenWithPeople,
                      onChanged: bloc.changeHaveBeenWithPeople,
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

  onSubmitForm(FormBloc bloc) {
    final errorMessage = _isValidForm(bloc);
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
    Navigator.pushNamed(context, SignaturePage.routeName);
  }

  String _isValidForm(FormBloc bloc) {
    if (bloc.yourSymptoms == 1 && bloc.yourSymptomsDesc.isEmpty) {
      return 'Indique sus síntomas';
    } else if (bloc.haveBeenIsolated == 0 &&
        bloc.haveBeenIsolatedDesc.isEmpty) {
      return 'Indique por que no ha estado aislado';
    } else if (bloc.haveBeenVisited == 1 && bloc.haveBeenVisitedDesc.isEmpty) {
      return 'Indique por que ha realizado visitas';
    }
    return '';
  }
}
