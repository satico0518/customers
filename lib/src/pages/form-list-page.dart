import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/pages/form-detail-page.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class FormList extends StatefulWidget {
  static final String routeName = 'formlist';

  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormList> {
  List<DocumentSnapshot> _listData = [];

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado'),
        actions: [
          Row(
            children: <Widget>[
              Text('CSV'),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () => _downloadCsv(),
              ),
            ],
          )
        ],
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
                      .where('shopDocumentId', isEqualTo: bloc.shopDocumentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _listData = snapshot.data.documents;
                      return DataTable(
                        columns: [
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Temp.')),
                          DataColumn(label: Text('Ver')),
                        ],
                        rows: snapshot.data.documents
                            .map(
                              (item) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(item.data['lastDate'] ?? '')),
                                  DataCell(
                                      Text(item.data['temperature'] ?? '')),
                                  DataCell(FlatButton(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    textColor: Colors.white,
                                    onPressed: () =>
                                        _details(context, item.data),
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 4),
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

  _downloadCsv() async {
    List<List<dynamic>> dataToExport = [];
    _listData.forEach((element) {
      final List<dynamic> tempList = [];
      element.data.forEach((key, value) {
        tempList.add(value);
      });
      dataToExport.add(tempList);
    });
    String csv = const ListToCsvConverter().convert(dataToExport);
    final File txtfile = await writeFileContent(csv);
    final fileUrl = await uploadFile(txtfile, 'entrevistas_${DateTime.now().millisecondsSinceEpoch.toString()}.txt');
    final response = await sendFormListEmail(fileUrl);
    Fluttertoast.showToast(
      msg: response,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
