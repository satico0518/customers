import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-detail-page.dart';
import 'package:flutter/material.dart';

class FormList extends StatelessWidget {
  static final String routeName = 'formlist';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Listado de entrevistas'),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('Forms')
                      .where('shopId', isEqualTo: bloc.shopId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DataTable(
                        columns: [
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Tipo Iden.')),
                          DataColumn(label: Text('Identificación')),
                          DataColumn(label: Text('Nombres')),
                          DataColumn(label: Text('Apellidos')),
                          DataColumn(label: Text('Temperatura')),
                          DataColumn(label: Text('Ver')),
                        ],
                        rows: snapshot.data.documents
                            .map(
                              (item) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(item.data['lastDate'] ?? '')),
                                  DataCell(Text(
                                      item.data['identificationType'] ?? '')),
                                  DataCell(
                                      Text(item.data['identification'] ?? '')),
                                  DataCell(Text(item.data['name'] ?? '')),
                                  DataCell(Text(item.data['lastName'] ?? '')),
                                  DataCell(
                                      Text(item.data['temperature'] ?? '')),
                                  DataCell(FlatButton(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    textColor: Colors.white,
                                    onPressed: () => _details(context, item.data),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('ver'),
                                        Icon(Icons.search)
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _details(BuildContext context, Map<String, dynamic> data) {
    if (data.isEmpty) return;
    Navigator.of(context).pushNamed(FormDetail.routeName, arguments: data);
  }
}
