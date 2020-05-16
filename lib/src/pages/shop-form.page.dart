import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:customers/src/pages/login-page.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showPass = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Registro'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text('Actualizar Tienda'),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveShopData(
                      _scaffoldKey.currentState.showSnackBar, bloc),
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
              child: Column(
                children: <Widget>[
                  Text(
                    'Ingrese los datos de su Tienda',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getNitField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopBranchNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopCityField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopAddressField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopContactNameField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopPhoneField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getShopEmailField(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getPasswordField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    buttonColor: Theme.of(context).secondaryHeaderColor,
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      onPressed: () => _saveShopData(
                          _scaffoldKey.currentState.showSnackBar, bloc),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Registrar Tienda',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
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

  Widget _getNitField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopNitStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopNit,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'NIT',
            labelText: 'NIT',
            helperText: 'Ingrese el número de NIT',
            icon:
                Icon(Icons.trip_origin, color: Theme.of(context).primaryColor),
          ),
          validator: (value) {
            if (value.isEmpty) return 'NIT es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopNit,
        );
      },
    );
  }

  Widget _getShopNameField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopNameStream,
      builder: (context, snapshot) {
        return TextFormField(
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

  Widget _getShopCityField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopCityStream,
      builder: (context, snapshot) {
        return TextFormField(
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

  Widget _getShopAddressField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopAddressStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopAddress,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Dirección',
            labelText: 'Dirección',
            helperText: 'Ingrese la Dirección',
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

  Widget _getShopBranchNameField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopBranchNameStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.shopBranchName,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Sucursal',
            labelText: 'Sucursal',
            helperText: 'Ingrese el nombre de la sucursal',
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

  Widget _getShopContactNameField(UserBloc bloc) {
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

  Widget _getShopPhoneField(UserBloc bloc) {
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

  Widget _getShopEmailField(UserBloc bloc) {
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
                          title: Text("Por que un correo?"),
                          content: Text("Este correo electrónico sera usado para el proceso de ingreso y sera donde se envien los archivos con el listado de las entrevistas registradas.",
                          textAlign: TextAlign.justify,),
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
                  icon: Icon(Icons.info,
                      color: Theme.of(context).primaryColor))),
          validator: (value) {
            if (value.isEmpty) return 'Correo Electrónico es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopEmail,
        );
      },
    );
  }

  Widget _getPasswordField(UserBloc bloc) {
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

  _saveShopData(showSnackBar, UserBloc bloc) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        // todo
        if (bloc.shopFirebaseId == null || bloc.shopFirebaseId.isEmpty) {
          final FirebaseUser fbShop = await ShopFirebaseProvider.fb
              .signUp(bloc.shopEmail.trim(), bloc.shopPassword.trim());
          bloc.changeShopFirebaseId(fbShop.uid);
        }

        final shop = new ShopModel(
          firebaseId: bloc.shopFirebaseId.trim(),
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
        if (bloc.shopDocumentId == null || bloc.shopDocumentId.isEmpty) {
          final DocumentReference fbShop =
              await ShopFirebaseProvider.fb.addShopToFirebase(shop);
          bloc.changeShopDocumentId(fbShop.documentID);
          shop.documentId = bloc.shopDocumentId;
        }

        await ShopDBProvider.db.deleteShop();
        await ShopDBProvider.db.addShop(shop);
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
      final snackBar =
          SnackBar(content: Text('Todos los campos son obligatorios!'));
      showSnackBar(snackBar);
    }
  }
}
