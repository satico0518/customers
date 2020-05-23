import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:customers/src/pages/home-page.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/terms-page.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  static final String routeName = 'register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _inputDateCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _aceptTerms = false;
  bool _showPass = false;
  List<String> _identificationTypes = [
    '-- Tipo Documento --',
    'Cedula Ciudadanía',
    'NIT',
    'Cedula Extrangería',
    'Registro Civil',
    'Otro'
  ];
  String currentPassword;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    currentPassword = bloc.password ?? '';

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Registro'),
          actions: <Widget>[
            StreamBuilder<bool>(
                stream: bloc.userIsEditingStream,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: snapshot.data,
                    child: Row(
                      children: <Widget>[
                        Text('Actualizar Usuario'),
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            _aceptTerms = true;
                            _saveUserData(
                                _scaffoldKey.currentState.showSnackBar, bloc);
                          },
                        ),
                      ],
                    ),
                  );
                })
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
                  StreamBuilder<bool>(
                      stream: bloc.userIsEditingStream,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: !snapshot.data,
                          child: Column(
                            children: [
                              _createIdentificationTypeField(bloc),
                              SizedBox(
                                height: 10,
                              ),
                              _getIdentificationField(bloc),
                              SizedBox(
                                height: 10,
                              ),
                              _getEmailField(bloc),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }),
                  _getNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getLastNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _createGenreField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getBirthDateField(context, bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getContactField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getAddressField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getPasswordField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<bool>(
                    stream: bloc.userIsEditingStream,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: !snapshot.data,
                        child: Column(
                          children: [
                            _getTermsAndConditions(),
                            SizedBox(
                              height: 10,
                            ),
                            ButtonTheme(
                              minWidth: double.infinity,
                              buttonColor:
                                  Theme.of(context).secondaryHeaderColor,
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
                            ),
                          ],
                        ),
                      );
                    },
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.text,
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

  Widget _createGenreField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.userGenreStream,
      builder: (context, snapshot) {
        return Row(children: <Widget>[
          Icon(
            Icons.people,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 15),
          Expanded(
            child: DropdownButtonFormField(
                hint: Text('Seleccione Género'),
                value: bloc.userGenre,
                items: _getOptionsGenreDropdownItems(),
                validator: (value) {
                  if (value == null || value == '-- Género --')
                    return 'Género es obligatorio';
                  return null;
                },
                onChanged: bloc.changeUserGenre),
          )
        ]);
      },
    );
  }

  List<DropdownMenuItem<String>> _getOptionsGenreDropdownItems() {
    List<DropdownMenuItem<String>> list = new List();
    ['-- Género --', 'Masculino', 'Femenino'].forEach((type) {
      DropdownMenuItem<String> tempItem = new DropdownMenuItem(
        child: Text(type),
        value: type,
      );
      list.add(tempItem);
    });
    return list;
  }

  Widget _getBirthDateField(BuildContext context, UserBloc bloc) {
    return StreamBuilder<DateTime>(
        stream: bloc.userBirthDateStream,
        builder: (context, snapshot) {
          _inputDateCtrl.text = getFormatedDate(bloc.userBirthDate);
          return TextFormField(
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: 'Fecha de Nacimiento',
              labelText: 'Fecha de Nacimiento',
              helperText: 'Fecha (dd/mm/aaaa)',
              suffixIcon: Icon(
                Icons.perm_contact_calendar,
                color: Theme.of(context).primaryColor,
              ),
              icon: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context, bloc);
                },
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectDate(context, bloc);
            },
            controller: _inputDateCtrl,
            validator: (value) {
              if (value.isEmpty) return 'Fecha de nacimiento es Obligatorio';
              return null;
            },
          );
        });
  }

  void _selectDate(BuildContext context, UserBloc bloc) async {
    DateTime datetimePicker = await showDatePicker(
        context: context,
        initialDate: bloc.userBirthDate != null
            ? bloc.userBirthDate
            : new DateTime(new DateTime.now().year - 10),
        firstDate: new DateTime(1920),
        lastDate: new DateTime(new DateTime.now().year - 10),
        locale: Locale('es', 'ES'));

    if (datetimePicker != null) {
      setState(() {
        bloc.changeUserBirthDate(datetimePicker);
        _inputDateCtrl.text = DateFormat('dd-MM-yyyy').format(datetimePicker);
      });
    }
  }

  Widget _getLastNameField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userLastNameStream,
        builder: (context, snapshot) {
          return TextFormField(
            keyboardType: TextInputType.text,
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
            keyboardType: TextInputType.number,
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

  Widget _getAddressField(UserBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userAddressStream,
        builder: (context, snapshot) {
          return TextFormField(
            keyboardType: TextInputType.text,
            initialValue: bloc.userAddress,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Dirección',
              labelText: 'Dirección',
              helperText: 'Dirección de residencia, incluya ciudad',
              icon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (value) {
              if (value.isEmpty) return 'Dirección es obligatorio';
              return null;
            },
            onChanged: bloc.changeUserAddress,
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

  Container _getTermsAndConditions() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, .2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            checkColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).secondaryHeaderColor,
            value: _aceptTerms,
            onChanged: (value) => setState(() => _aceptTerms = value),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(TermsPage.routeName),
            child: Text(
              'Acepto términos y condiciones',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  bool _areTermsAccepted() {
    if (!_aceptTerms) {
      Fluttertoast.showToast(
        msg: 'Debe aceptar los términos y condiciones.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
    return true;
  }

  _saveUserData(showSnackBar, UserBloc bloc) async {
    if (_formKey.currentState.validate() && _areTermsAccepted()) {
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
          genre: bloc.userGenre.trim(),
          birthDate: bloc.userBirthDate,
          lastName: bloc.lastName.trim(),
          contact: bloc.contact.trim(),
          address: bloc.userAddress.trim(),
          email: bloc.email.trim(),
          password: bloc.password.trim(),
        );
        if (bloc.userDocumentId == null || bloc.userDocumentId.isEmpty) {
          final DocumentReference fbUser =
              await UserFirebaseProvider.fb.addUserToFirebase(user, "CUSTOMER");
          bloc.changeUserDocumentId(fbUser.documentID);
        }
        user.documentId = bloc.userDocumentId;
        await UserFirebaseProvider.fb
            .updateUserToFirebase(user, bloc.userDocumentId);
        await UserDBProvider.db.deleteUser();
        await UserDBProvider.db.addUser(user);
        Fluttertoast.showToast(
          msg: 'Registro exitoso!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );

        if (currentPassword != bloc.password) {
          await UserFirebaseProvider.fb.changePassword(bloc.password);
          bloc.changeUserIsLogged(false);
          Navigator.pushNamed(context, LoginPage.routeName);
        } else
          Navigator.pushNamed(context, HomePage.routeName);
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
