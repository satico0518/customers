import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/form-page.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static final String routeName = 'register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _identificationTypes = [
    '-- Tipo Documento --',
    'Cedula Ciudadanía',
    'NIT',
    'Cedula Extrangería',
    'Registro Civil',
    'Otro'
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Registro'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text('Actualizar Usuario'),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveUserData(_scaffoldKey.currentState.showSnackBar, bloc, true),
                ),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _createIdentificationTypeField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getIdentificationField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getNameField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getLastNameField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getContactField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getEmailField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    buttonColor: Theme.of(context).secondaryHeaderColor,
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      onPressed: () => _saveUserData(
                          _scaffoldKey.currentState.showSnackBar, bloc, false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Diligenciar Encuesta',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Icon(
                            Icons.content_paste,
                            color: Colors.white,
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createIdentificationTypeField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userIdTypeStream,
        builder: (context, snapshot) {
          return Row(children: <Widget>[
            Icon(Icons.select_all),
            SizedBox(width: 30),
            Expanded(
              child: DropdownButtonFormField(
                hint: Text('Seleccione tipo de documento'),
                value: snapshot.data,
                items: _getOptionsDropdownItems(),
                validator: (String value) {
                  if (value == '-- Tipo Documento --')
                    return 'Tipo de documento es obligatorio';
                  return null;
                },
                onChanged: bloc.changeUserIdType,
              ),
            )
          ]);
        });
  }

  List<DropdownMenuItem<String>> _getOptionsDropdownItems() {
    List<DropdownMenuItem<String>> list = new List();
    _identificationTypes.forEach((type) {
      DropdownMenuItem<String> tempItem = new DropdownMenuItem(
        child: Text(type),
        value: type,
      );
      list.add(tempItem);
    });
    return list;
  }

  Widget _getIdentificationField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userIdStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.identification,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: 'Numero de Identificación',
                labelText: 'Identificación',
                helperText: 'Numero de Identificación sin puntos ni comas',
                icon: Icon(Icons.call_to_action),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (value.isEmpty)
                return 'Numero de Identificación es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserId,
          );
        });
  }

  Widget _getNameField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userNameStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: 'Nombre',
                labelText: 'Nombre',
                helperText: 'Ingrese su nombre',
                icon: Icon(Icons.account_circle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (value.isEmpty) return 'Nombre es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserName,
          );
        });
  }

  Widget _getLastNameField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userLastNameStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.lastName,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: 'Apellido',
                labelText: 'Apellido',
                helperText: 'Ingrese su apellido',
                icon: Icon(Icons.account_circle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (value.isEmpty) return 'Apellido es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserLastName,
          );
        });
  }

  Widget _getContactField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userContactStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.contact,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: 'Numero de contacto',
                labelText: 'Numero de contacto',
                helperText: 'Celular o fijo',
                icon: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (value.isEmpty) return 'Numero de contacto es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserContact,
          );
        });
  }

  Widget _getEmailField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userEmailStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.email,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: 'Correo Electrónico',
                labelText: 'Correo Electrónico',
                helperText: 'correo@dominio.com',
                icon: Icon(Icons.email),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (value.isEmpty) return 'Correo Electrónico es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserEmail,
          );
        });
  }

  _saveUserData(showSnackBar, UserBloc bloc, bool onlySave) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final user = new UserModel(
          id: 1,
          identificationType: bloc.identificationType.trim(),
          identification: bloc.identification.trim(),
          name: bloc.name.trim(),
          lastName: bloc.lastName.trim(),
          contact: bloc.contact.trim(),
          email: bloc.email.trim());
      await UserDBProvider.db.deleteUser();
      await UserDBProvider.db.addUser(user);
      if (!onlySave) Navigator.pushNamed(context, FormPage.routeName);
    } else {
      final snackBar =
          SnackBar(content: Text('Todos los campos son obligatorios!'));
      showSnackBar(snackBar);
    }
  }
}
