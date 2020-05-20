import 'dart:ui';

import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
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
  String _branchName = '';
  String _branchAddress = '';
  ShopBranchModel _currentBranch;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucursales'),
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                _branchName = '';
                _branchAddress = '';
                _addBranch(context, bloc, false);
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<ShopBranchModel>(
                    stream: bloc.shopCurrBranchStream,
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
                                  ', si desea cambiar de Sucursal seleccione alguna de la lista inferior.',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
          StreamBuilder<List<ShopBranchModel>>(
            stream: bloc.shopBranchesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text('cargando sucursales...'),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: Expanded(
                    child: FutureBuilder<List<ShopBranchModel>>(
                      future: ShopDBProvider.db.getShopBranchs(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: true,
                                dataRowHeight: 30,
                                columns: [
                                  DataColumn(label: Text('Nombre')),
                                  DataColumn(label: Text('Dirección')),
                                  DataColumn(label: Text('')),
                                ],
                                rows: snapshot.data
                                    .map<DataRow>(
                                      (ShopBranchModel item) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      bloc.changeShopCurrBranch(
                                                          item),
                                                  child: Icon(
                                                    Icons.adjust,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(capitalizeWord(
                                                    item.branchName ?? ''))
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                              Text(item.branchAddress ?? '')),
                                          DataCell(
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              onPressed: () {
                                                setState(() {
                                                  _branchName = capitalizeWord(
                                                      item.branchName ?? '');
                                                  _branchAddress =
                                                      item.branchAddress;
                                                  _currentBranch = item;
                                                  _addBranch(
                                                      context, bloc, true);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
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
                                  'cargando entrevistas...',
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
              );
            },
          ),
        ],
      ),
    );
  }

  _addBranch(BuildContext context, UserBloc bloc, bool isUpdate) {
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
                        child: RaisedButton(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Text(
                            "Guardar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (isUpdate)
                                _updateBranch(bloc);
                              else
                                _saveNewBranch(bloc);
                            }
                          },
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

  void _saveNewBranch(UserBloc bloc) async {
    final branch = ShopBranchModel(
      branchName: _branchName,
      branchAddress: _branchAddress,
      shopDocumentId: bloc.shopDocumentId,
    );
    branch.branchDocumentId =
        (await ShopFirebaseProvider.fb.addShopBranchToFirebase(branch))
            .documentID;
    await ShopFirebaseProvider.fb.updateShopBranchFirebase(branch);
    await ShopDBProvider.db.addShopBranch(branch);
    final branchesFb = await ShopFirebaseProvider.fb
        .getBranchsFbByShopDocId(bloc.shopDocumentId);
    final List<ShopBranchModel> branches = branchesFb.documents
        .map((e) => ShopBranchModel.fromJson(e.data))
        .toList();
    bloc.changeShopBranches(branches);
    Navigator.of(context).pop();
  }

  void _updateBranch(UserBloc bloc) async {
    _currentBranch.branchName = _branchName;
    _currentBranch.branchAddress = _branchAddress;
    await ShopDBProvider.db.updateShopBranch(_currentBranch);
    await ShopFirebaseProvider.fb.updateShopBranchFirebase(_currentBranch);
    bloc.changeShopBranches(await ShopDBProvider.db.getShopBranchs());
    if (bloc.shopCurrBranch.branchDocumentId == _currentBranch.branchDocumentId)
      bloc.changeShopCurrBranch(_currentBranch);
    Navigator.of(context).pop();
  }
}
