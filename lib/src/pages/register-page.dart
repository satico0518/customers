import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:customers/src/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  static final String routeName = 'register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
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
    final Map<String, dynamic> _onlySave =
        ModalRoute.of(context).settings.arguments ?? {"onlySave": false};
    final bloc = Provider.of(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Registro Visitante'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text('Actualizar Usuario'),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveUserData(
                    _scaffoldKey.currentState.showSnackBar,
                    bloc,
                  ),
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
                    height: 10,
                  ),
                  _getIdentificationField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getLastNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getContactField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getEmailField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getPasswordField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: !_onlySave['onlySave'] ?? true,
                    child: StreamBuilder<String>(
                      stream: bloc.userFirebaseIdStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ButtonTheme(
                            minWidth: double.infinity,
                            buttonColor: Theme.of(context).secondaryHeaderColor,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              onPressed: () => _saveUserData(
                                _scaffoldKey.currentState.showSnackBar,
                                bloc,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'Registrarme',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
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
            Icon(
              Icons.select_all,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 15),
            Expanded(
              child: DropdownButtonFormField(
                hint: Text('Seleccione tipo de documento'),
                value: bloc.identificationType,
                items: _getOptionsDropdownItems(),
                validator: (value) {
                  if (value == null || value == '-- Tipo Documento --')
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
        stream: bloc.userIdentificationStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.identification,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Numero de Identificación',
              labelText: 'Identificación',
              helperText: 'Numero de Identificación sin puntos ni comas',
              icon: Icon(
                Icons.call_to_action,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (value) {
              if (value.isEmpty)
                return 'Numero de Identificación es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserIdentification,
          );
        });
  }

  Widget _getNameField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userNameStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: bloc.userName,
          textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Nombre',
              labelText: 'Nombre',
              helperText: 'Ingrese su nombre',
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
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
          textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Apellido',
              labelText: 'Apellido',
              helperText: 'Ingrese su apellido',
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
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
          textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Numero de contacto',
              labelText: 'Numero de contacto',
              helperText: 'Celular o fijo',
              icon: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
            ),
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
          decoration: InputDecoration(
            hintText: 'Correo Electrónico',
            labelText: 'Correo Electrónico',
            helperText: 'correo@dominio.com',
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColor,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Correo Electrónico es obligatorio';
            return null;
          },
          onChanged: bloc.changeUserEmail,
        );
      },
    );
  }

  Widget _getPasswordField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.userPasswordStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.password,
          obscureText: !_showPass,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              labelText: 'Contraseña',
              helperText: 'mínimo 6 caracteres',
              icon: Icon(
                Icons.vpn_key,
                color: Theme.of(context).primaryColor,
              ),
              suffixIcon: IconButton(
                  onPressed: () => setState(() => _showPass = !_showPass),
                  icon: Icon(Icons.remove_red_eye))),
          validator: (value) {
            if (value.isEmpty) return 'Contraseña es obligatorio';
            if (value.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
          onChanged: bloc.changeUserPassword,
        );
      },
    );
  }

  _saveUserData(showSnackBar, UserBloc bloc) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        // todo
        if (bloc.userFirebaseId == null || bloc.userFirebaseId.isEmpty) {
          final FirebaseUser fbUser = await UserFirebaseProvider.fb
              .signUp(bloc.email.trim(), bloc.password.trim());
          bloc.changeUserFirebaseId(fbUser.uid);
        }

        final user = new UserModel(
          firebaseId: bloc.userFirebaseId,
          identificationType: bloc.identificationType.trim(),
          identification: bloc.identification.trim(),
          name: bloc.userName.trim(),
          lastName: bloc.lastName.trim(),
          contact: bloc.contact.trim(),
          email: bloc.email.trim(),
          password: bloc.password.trim(),
        );
        if (bloc.userDocumentId == null || bloc.userDocumentId.isEmpty) {
          final DocumentReference fbUser = await UserFirebaseProvider.fb.addUserToFirebase(user);
          bloc.changeUserDocumentId(fbUser.documentID);
          user.documentId = bloc.userDocumentId;
        }
          
        await UserDBProvider.db.deleteUser();
        await UserDBProvider.db.addUser(user);
        Fluttertoast.showToast(
          msg: 'Registro exitoso!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        Navigator.pushNamed(context, LoginPage.routeName);
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: ${handleMessage(e.toString())}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      }
    } else {
      final snackBar = SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Todos los campos son obligatorios!'));
      showSnackBar(snackBar);
    }
  }
}
