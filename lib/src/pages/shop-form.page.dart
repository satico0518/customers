import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:customers/src/pages/qr-reader-page.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:flutter/material.dart';

class ShopForm extends StatefulWidget {
  static final String routeName = 'shopform';
  @override
  _ShopFormState createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  SizedBox(
                    height: 20,
                  ),
                  Text('Ingrese los datos de su Tienda', style: TextStyle(fontSize: 18),),
                  SizedBox(
                    height: 20,
                  ),

                  _getNitField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getShopNameField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getShopContactNameField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getShopPhoneField(bloc),
                  SizedBox(
                    height: 20,
                  ),
                  _getShopEmailField(bloc),
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
                            'Guardar Tienda',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Icon(
                            Icons.save,
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

  Widget _getNitField(UserBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.shopNitStream,
      builder: (context, snapshot) {
        return TextFormField(
          initialValue: bloc.nit,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'NIT',
            labelText: 'NIT',
            helperText: 'Ingrese el número de NIT',
            icon: Icon(Icons.trip_origin),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          initialValue: bloc.shopname,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Tienda',
            labelText: 'Tienda',
            helperText: 'Ingrese el nombre de la tienda',
            icon: Icon(Icons.store_mall_directory),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) return 'Tienda es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopName,
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
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Contacto',
            labelText: 'Persona Contacto',
            helperText: 'Nombre de la persona de contacto',
            icon: Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Teléfono',
            labelText: 'Teléfono Contacto',
            helperText: 'Teléfono de contacto',
            icon: Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          initialValue: bloc.shopemail,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              hintText: 'Correo Electrónico',
              labelText: 'Correo Electrónico',
              helperText: 'correo@dominio.com',
              icon: Icon(Icons.email),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          validator: (value) {
            if (value.isEmpty) return 'Correo Electrónico es obligatorio';
            return null;
          },
          onChanged: bloc.changeShopEmail,
        );
      },
    );
  }

  _saveShopData(showSnackBar, UserBloc bloc) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final shop = new ShopModel(
          id: 1,
          nit: bloc.nit.trim(),
          name: bloc.shopname.trim(),
          contactName: bloc.contactName.trim(),
          email: bloc.shopemail.trim(),
          phone: bloc.phone.trim());
      await ShopDBProvider.db.deleteShop();
      await ShopDBProvider.db.addShop(shop);
      Navigator.pushNamed(context, QRReaderPage.routeName);
    } else {
      final snackBar =
          SnackBar(content: Text('Todos los campos son obligatorios!'));
      showSnackBar(snackBar);
    }
  }
}
