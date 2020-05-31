import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/shop.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/pages/terms-page.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:customers/src/providers/userFirebase.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:customers/src/utils/utils.dart';

class ShopForm extends StatefulWidget {
  static final String routeName = 'shopform';
  @override
  _ShopFormState createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  ShopBloc _shopBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _aceptTerms = false;
  bool _showPass = false;
  bool _isRegistering = false;
  String _currentPassword;

  @override
  Widget build(BuildContext context) {
    _shopBloc = Provider.shopBloc(context);
    _currentPassword = _shopBloc.shopPassword ?? '';
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Registro'),
          actions: <Widget>[
            StreamBuilder<bool>(
                stream: _shopBloc.shopIsEditingStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Visibility(
                      visible: snapshot.data,
                      child: Row(
                        children: <Widget>[
                          Text('Guardar'),
                          _isRegistering
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : IconButton(
                                  icon: Icon(Icons.save),
                                  onPressed: () {
                                    _aceptTerms = true;
                                    _saveShopData(
                                        _scaffoldKey.currentState.showSnackBar,
                                        _shopBloc);
                                  },
                                ),
                        ],
                      ),
                    );
                  }
                  return Text('');
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Ingrese los datos de su Comercio',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<bool>(
                      stream: _shopBloc.shopIsEditingStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('');
                        return Visibility(
                            visible: !snapshot.data, child: _getNitField(_shopBloc));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopNameField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<bool>(
                    stream: _shopBloc.shopIsEditingStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');
                      return Visibility(
                          visible: !snapshot.data,
                          child: _getShopBranchNameField(_shopBloc));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopCityField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopAddressField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopContactNameField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopPhoneField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getPasswordField(_shopBloc),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<bool>(
                    stream: _shopBloc.shopIsEditingStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');
                      return Visibility(
                        visible: !snapshot.data,
                        child: Column(
                          children: [
                            _getShopEmailField(_shopBloc),
                            SizedBox(
                              height: 10,
                            ),
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
                                onPressed: () => _isRegistering
                                    ? null
                                    : _saveShopData(
                                        _scaffoldKey.currentState.showSnackBar,
                                        _shopBloc),
                                child: _isRegistering
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        'Registrar Comercio',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            )
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

  Widget _getNitField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopNitStream,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.number,
          initialValue: bloc.shopNit,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'NIT',
            labelText: 'NIT',
            helperText: 'NIT sin dígito de verificación',
            icon:
                Icon(Icons.trip_origin, color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'NIT es obligatorio';
            if (value.contains('-')) {
              bloc.changeShopNit(value.split('-')[0]);
              return 'ingrese NIT sin dígito de verificación';
            }
            return null;
          },
          onChanged: bloc.changeShopNit,
        );
      },
    );
  }

  Widget _getShopNameField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopNameStream,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.text,
          initialValue: bloc.shopName,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Razón Social',
            labelText: 'Razón Social',
            helperText: 'Ingrese la Razón Social',
            icon: Icon(Icons.store_mall_directory,
                color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Razón Social es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopName,
        );
      },
    );
  }

  Widget _getShopCityField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopCityStream,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.text,
          initialValue: bloc.shopCity,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Ciudad',
            labelText: 'Ciudad',
            helperText: 'Ingrese la Ciudad',
            icon: Icon(Icons.location_city,
                color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Ciudad es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopCity,
        );
      },
    );
  }

  Widget _getShopAddressField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopAddressStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopAddress,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Dirección',
            labelText: 'Dirección',
            helperText: 'Ingrese la Dirección de la sucursal inicial',
            icon: Icon(Icons.directions, color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Dirección es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopAddress,
        );
      },
    );
  }

  Widget _getShopBranchNameField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopBranchNameStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopBranchName,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Sucursal',
            labelText: 'Sucursal',
            helperText: 'Ingrese el nombre de la sucursal inicial',
            icon: Icon(Icons.shopping_basket,
                color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Sucursal es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopBranchName,
        );
      },
    );
  }

  Widget _getShopContactNameField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopContactNameStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.contactName,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Contacto',
            labelText: 'Persona Contacto',
            helperText: 'Nombre de la persona de contacto',
            icon: Icon(Icons.person, color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Contacto es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopContactName,
        );
      },
    );
  }

  Widget _getShopPhoneField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopPhoneStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.phone,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Teléfono',
            labelText: 'Teléfono Contacto',
            helperText: 'Teléfono de contacto',
            icon: Icon(Icons.phone, color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Teléfono es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopPhone,
        );
      },
    );
  }

  Widget _getShopEmailField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopEmailStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Correo Electrónico',
              labelText: 'Correo Electrónico',
              helperText: 'correo@dominio.com',
              icon: Icon(Icons.email, color: Theme.of(context).primaryColor),
              suffixIcon: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Por qué un correo?"),
                          content: Text(
                            "Este correo electrónico será usado para el proceso de ingreso y será donde se envíen los archivos con el listado de las encuestas registradas.",
                            textAlign: TextAlign.justify,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon:
                      Icon(Icons.info, color: Theme.of(context).primaryColor))),
          validator: (value) {
            if (value.isEmpty) return 'Correo Electrónico es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopEmail,
        );
      },
    );
  }

  Widget _getPasswordField(ShopBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopPasswordStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopPassword,
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
                  icon: Icon(Icons.remove_red_eye,
                      color: Theme.of(context).primaryColor))),
          validator: (value) {
            if (value.isEmpty) return 'Contraseña es obligatorio';
            if (value.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
          onChanged: bloc.changeShopPassword,
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

  _saveShopData(showSnackBar, ShopBloc bloc) async {
    if (_formKey.currentState.validate() && _areTermsAccepted()) {
      _formKey.currentState.save();
      setState(() => _isRegistering = true);
      try {
        final shop = new ShopModel(
          nit: bloc.shopNit.trim(),
          name: bloc.shopName.trim(),
          address: bloc.shopAddress.trim(),
          city: bloc.shopCity.trim(),
          branchName: bloc.shopBranchName.trim(),
          contactName: bloc.contactName.trim(),
          phone: bloc.phone.trim(),
          email: bloc.shopEmail.trim(),
          password: bloc.shopPassword.trim(),
        );
        if (bloc.shopFirebaseId == null || bloc.shopFirebaseId.isEmpty) {
          final FirebaseUser fbShop = await ShopFirebaseProvider.fb
              .signUp(bloc.shopEmail.trim(), bloc.shopPassword.trim());
          fbShop.sendEmailVerification();
          bloc.changeShopFirebaseId(fbShop.uid);
        }
        shop.firebaseId = bloc.shopFirebaseId;

        if (bloc.shopDocumentId == null || bloc.shopDocumentId.isEmpty) {
          final DocumentReference fbShop =
              await UserFirebaseProvider.fb.addUserToFirebase(shop, "SHOP");
          bloc.changeShopDocumentId(fbShop.documentID);
        }
        shop.documentId = bloc.shopDocumentId;
        UserFirebaseProvider.fb.updateUserToFirebase(shop, bloc.shopDocumentId);
        await ShopDBProvider.db.deleteShop();
        await ShopDBProvider.db.addShop(shop);
        if (bloc.shopCurrBranch == null) {
          final branch = ShopBranchModel(
            shopDocumentId: bloc.shopDocumentId,
            branchName: bloc.shopBranchName,
            branchAddress: bloc.shopAddress,
            branchMemo: 'Sucursal Inicial',
            capacity: 0,
            maxCapacity: 10,
          );
          final branchRef =
              await ShopFirebaseProvider.fb.addShopBranchToFirebase(branch);
          branch.branchDocumentId = branchRef.documentID;
          await ShopFirebaseProvider.fb.updateShopBranchFirebase(branch);
          bloc.changeShopCurrBranch(branch);
        }
        Fluttertoast.showToast(
          msg: 'Registro exitoso!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );

        if (_currentPassword != bloc.shopPassword) {
          UserFirebaseProvider.fb.changePassword(bloc.shopPassword);
          bloc.changeShopIsLogged(false);
          Navigator.pushNamed(context, LoginPage.routeName);
          setState(() => _isRegistering = false);
          return;
        }

        if (bloc.shopIsLogged != null && bloc.shopIsLogged)
          Navigator.pushNamed(context, QRReaderPage.routeName);
        else
          Navigator.pushNamed(context, LoginPage.routeName);

        setState(() => _isRegistering = false);
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

        setState(() => _isRegistering = false);
      }
    } else {
      final snackBar =
          SnackBar(content: Text('Todos los campos son obligatorios!'));
      showSnackBar(snackBar);
    }
  }
}
