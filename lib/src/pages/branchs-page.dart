import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/shop.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/pages/branch-detail-page.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BranchPage extends StatefulWidget {
  static final String routeName = 'branch';

  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final _formKey = GlobalKey<FormState>();
  ShopBloc _shopBloc;
  String _branchName = '';
  String _branchAddress = '';
  int _branchMaxcapacity = 0;
  ShopBranchModel _currentBranch;

  @override
  Widget build(BuildContext context) {
    _shopBloc = Provider.shopBloc(context);
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sucursales'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _branchName = '';
                _branchAddress = '';
                _branchMaxcapacity = 0;
                _addBranch(context, _shopBloc, false);
              })
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<ShopBranchModel>(
                      stream: _shopBloc.shopCurrBranchStream,
                      builder: (context, snapshot) {
                        return RichText(
                          text: TextSpan(
                            text:
                                'Usted está actualmente registrando sobre la sucursal ',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${snapshot.hasData ? capitalizeWord(snapshot.data.branchName) : ''}',
                                style: TextStyle(
                                    letterSpacing: 5,
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    color: Colors.white,
                                    fontSize: 22),
                              ),
                              TextSpan(
                                text:
                                    ' , si desea cambiar de Sucursal seleccione alguna de la lista inferior haciendo click en el círculo verde.',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Branches')
                        .where('shopDocumentId',
                            isEqualTo: _shopBloc.shopDocumentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final items = snapshot.data.documents;
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Theme.of(context).primaryColor,
                              thickness: 3,
                            );
                          },
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              leading: GestureDetector(
                                onLongPress: () =>
                                    _resetCounter(items[index].data),
                                onTap: () {
                                  _shopBloc.changeShopCurrBranch(
                                      ShopBranchModel.fromJson(
                                          items[index].data));
                                  _shopBloc.changeShopBranchName(
                                      items[index].data['branchName']);
                                  _prefs.currentBranch =
                                      ShopBranchModel.fromJson(
                                          items[index].data);
                                },
                                child: CircleAvatar(
                                  backgroundColor: _setBackColor(
                                      context, items[index].data),
                                  child: Text(
                                    items[index].data['capacity'] != null
                                        ? items[index]
                                            .data['capacity']
                                            .toString()
                                        : '0',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              title: RichText(
                                text: TextSpan(
                                    text: items[index]['branchName'],
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                          text:
                                              ' - Max (${items[index].data['maxCapacity'] != null ? items[index].data['maxCapacity'].toString() : '0'})',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ))
                                    ]),
                              ),
                              subtitle: Text(items[index]['branchAddress']),
                              trailing: SizedBox(
                                width: 70,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.open_with,
                                        color: Theme.of(context).primaryColor,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        _shopBloc.changeShopCurrBranch(
                                            ShopBranchModel.fromJson(
                                                items[index].data));
                                        _shopBloc.changeShopBranchName(
                                            items[index].data['branchName']);
                                        _prefs.currentBranch =
                                            ShopBranchModel.fromJson(
                                                items[index].data);
                                        Navigator.of(context).pushNamed(
                                            BranchDetail.routeName);
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _branchName = capitalizeWord(
                                              items[index]
                                                      .data['branchName'] ??
                                                  '');
                                          _branchAddress = items[index]
                                              .data['branchAddress'];
                                          _branchMaxcapacity = items[index]
                                                  .data['maxCapacity'] ??
                                              0;
                                          _currentBranch =
                                              ShopBranchModel.fromJson(
                                                  items[index].data);
                                          _addBranch(
                                              context, _shopBloc, true);
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 4),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'cargando encuestas...',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addBranch(BuildContext context, ShopBloc bloc, bool isUpdate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        isUpdate ? 'Editar Sucursal' : 'Nueva Sucursal',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0).copyWith(top: 0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          initialValue: _branchName,
                          decoration: InputDecoration(
                            labelText: 'Nombre sucursal',
                          ),
                          validator: (value) {
                            if (value.isEmpty) return 'Nombre es obligatorio';
                            return null;
                          },
                          onChanged: (value) =>
                              setState(() => _branchName = value),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0).copyWith(top: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                          initialValue: _branchMaxcapacity.toString(),
                          decoration: InputDecoration(
                            labelText: 'Aforo Máximo',
                          ),
                          validator: (value) {
                            if (value == '0') return 'Aforo es obligatorio';
                            return null;
                          },
                          onChanged: (value) => setState(
                              () => _branchMaxcapacity = int.parse(value)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0).copyWith(top: 3),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          initialValue: _branchAddress,
                          decoration: InputDecoration(
                            labelText: 'Dirección',
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Dirección es obligatorio';
                            return null;
                          },
                          onChanged: (value) =>
                              setState(() => _branchAddress = value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => deleteBranch(_currentBranch),
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                            ),
                            RaisedButton(
                              color: Theme.of(context).secondaryHeaderColor,
                              child: Text(
                                "Guardar",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if (isUpdate)
                                    _updateBranch(_shopBloc);
                                  else
                                    _saveNewBranch(_shopBloc);
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveNewBranch(ShopBloc bloc) async {
    final branch = ShopBranchModel(
      branchName: _branchName,
      branchAddress: _branchAddress,
      shopDocumentId: bloc.shopDocumentId,
      capacity: 0,
      maxCapacity: _branchMaxcapacity,
    );
    branch.branchDocumentId =
        (await ShopFirebaseProvider.fb.addShopBranchToFirebase(branch))
            .documentID;
    ShopFirebaseProvider.fb.updateShopBranchFirebase(branch);
    Navigator.of(context).pop();
  }

  void _updateBranch(ShopBloc bloc) async {
    _currentBranch.branchName = _branchName;
    _currentBranch.branchAddress = _branchAddress;
    _currentBranch.maxCapacity = _branchMaxcapacity;
    ShopFirebaseProvider.fb.updateShopBranchFirebase(_currentBranch);
    if (bloc.shopCurrBranch.branchDocumentId == _currentBranch.branchDocumentId)
      bloc.changeShopCurrBranch(_currentBranch);
    Navigator.of(context).pop();
  }

  Color _setBackColor(BuildContext context, Map<String, dynamic> data) {
    if (data['maxCapacity'] == null || data['maxCapacity'] == 0) {
      return Theme.of(context).primaryColor;
    }
    final maxCapacity = data['maxCapacity'];
    final capacity = data['capacity'] ?? 0;
    final currentPercentage = (capacity * 100) / maxCapacity;
    if (currentPercentage < 80) {
      return Theme.of(context).secondaryHeaderColor;
    } else if (currentPercentage >= 80 && currentPercentage < 99) {
      return Colors.orangeAccent;
    } else
      return Colors.redAccent;
  }

  _resetCounter(Map<String, dynamic> branch) {
    _showAppAlert(
      text:
          'Esta a punto de reiniciar el conteo del aforo actual para la sucursal ${branch['branchName']}. Está seguro de reiniciar el contador?',
      actionButton: FlatButton(
        color: Colors.white,
        child: Text(
          "Reiniciar",
          style: TextStyle(color: Colors.redAccent),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          ShopFirebaseProvider.fb
              .resetBranchCapacity(branch['branchDocumentId']);
          return;
        },
      ),
    );
  }

  deleteBranch(ShopBranchModel currentBranch) async {
    if (!(await ShopFirebaseProvider.fb
        .checkIfBranchCanBeRemoved(currentBranch.branchDocumentId))) {
      _showAppAlert(
          text:
              'No es posible eliminar esta sucursal ya que tiene códigos registrados en la base de datos!');
      return;
    }

    _showAppAlert(
      text:
          'Esta a punto de eliminar la sucursal ${currentBranch.branchName}. Está seguro de eliminar esta sucursal?',
      actionButton: FlatButton(
        color: Colors.white,
        child: Text(
          "Eliminar",
          style: TextStyle(color: Colors.redAccent),
        ),
        onPressed: () {
          ShopFirebaseProvider.fb.deleteBranch(currentBranch.branchDocumentId);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return;
        },
      ),
    );
  }

  _showAppAlert({String text, FlatButton actionButton}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
          titleTextStyle: TextStyle(color: Colors.white),
          contentTextStyle: TextStyle(color: Colors.white),
          title: Text(
            'Atención!',
            style: TextStyle(fontSize: 30),
          ),
          content: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            actionButton,
            SizedBox(
              width: 20,
            ),
            FlatButton(
              color: Colors.white,
              child: Text(
                "Cancelar",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }
}
