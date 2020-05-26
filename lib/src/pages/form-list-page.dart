import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/user.bloc.dart';
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
  bool _sortDateDesc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Encuestas registradas',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Row(
            children: <Widget>[
              Text('CSV'),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () => _downloadCsv(bloc),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'Listado de encuestas - ${capitalizeWord(bloc.shopCurrBranch.branchName)}.'),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('Forms')
                    .where('shopBranchDocumentId',
                        isEqualTo: bloc.shopCurrBranch.branchDocumentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _listData = snapshot.data.documents;
                    _listData.sort((item1, item2) =>
                        item2["insertDate"].compareTo(item1["insertDate"]));
                    return Container(
                      height: MediaQuery.of(context).size.height * .75,
                      color: Colors.grey[200],
                      width: double.infinity,
                      child: Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAsc,
                            dataRowHeight: 25,
                            columns: [
                              DataColumn(
                                  label: Text('Fecha'),
                                  onSort: (colInx, sortAsc) {
                                    setState(() {
                                      if (colInx == _sortColumnIndex) {
                                        _sortAsc = _sortDateDesc = sortAsc;
                                      } else {
                                        _sortColumnIndex = colInx;
                                        _sortAsc = _sortDateDesc;
                                      }
                                      _listData.sort((a, b) => a
                                          .data['insertDate']
                                          .compareTo(b.data['insertDate']));
                                      if (!sortAsc)
                                        _listData = _listData.reversed.toList();
                                    });
                                  }),
                              DataColumn(label: Text('Temp.')),
                              DataColumn(label: Text('Ver')),
                            ],
                            rows: _listData.map((item) {
                              Icon gettingInIcon;
                              if (item.data['gettingIn'] != null) {
                                if (item.data['gettingIn'])
                                  gettingInIcon = Icon(
                                    Icons.arrow_downward,
                                    color: Colors.green,
                                    size: 15,
                                  );
                                else
                                  gettingInIcon = Icon(
                                    Icons.arrow_upward,
                                    color: Colors.red,
                                    size: 15,
                                  );
                              } else
                                gettingInIcon = Icon(
                                  Icons.block,
                                  color: Colors.white,
                                  size: 1,
                                );
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Row(
                                    children: [
                                      gettingInIcon,
                                      Text(getStringDateFromtimestamp(
                                          item.data['insertDate'])),
                                    ],
                                  )),
                                  DataCell(
                                      Text(item.data['temperature'] ?? '')),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () => _details(context, item.data),
                                      child: Container(
                                        width: 20,
                                        child: Icon(
                                          Icons.search,
                                          size: 20,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
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
                            'cargando encuestas...',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    );
                  }
                },
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

  _downloadCsv(UserBloc bloc) async {
    if (_listData.length == 0) return;
    List<List<dynamic>> dataToExport = [
      [
        "Fecha de registro",
        "Tipo de Registro",
        "Razon Social",
        "Sucursal",
        "Temperatura",
        "Tipo Identificacion",
        "Identificacion",
        "Nombres",
        "Apellidos",
        "Telefono",
        "Email",
        "Presenta Sintomas",
        "Observacion Sintomas",
        "Hogar con Sintomas",
        "En Aislamiento",
        "Observacion Aislamiento",
        "Visitas",
        "Observacion Visitas",
        "Mas de 10 Personas",
        "Es Visitante",
        "Acepta informacion veridica",
        "Empleado acepta informar sus sintomas",
        "Empleado acepta informar sintomas hogar",
        "Empleado acepta informar sintomas futuros"
      ]
    ];
    _listData.forEach((element) {
      final data = element.data;
      final orderedItem = [
        getStringDateFromtimestamp(data['insertDate']),
        data['gettingIn'] != null
            ? (data['gettingIn'] == true ? 'Ingreso' : 'Salida')
            : 'N/A',
        bloc.shopName,
        bloc.shopCurrBranch.branchName,
        data['temperature'],
        data['identificationType'],
        data['identification'],
        data['name'],
        data['lastName'],
        data['contact'],
        data['email'],
        data['yourSymptoms'] == 1 ? 'SI' : 'NO',
        data['yourSymptomsDesc'],
        data['yourHomeSymptoms'] == 1 ? 'SI' : 'NO',
        data['haveBeenIsolated'] == 1 ? 'SI' : 'NO',
        data['haveBeenIsolatedDesc'],
        data['haveBeenVisited'] == 1 ? 'SI' : 'NO',
        data['haveBeenVisitedDesc'],
        data['haveBeenWithPeople'] == 1 ? 'SI' : 'NO',
        data['isEmployee'] == 0 ? 'SI' : 'NO',
        data['visitorAccept'] == 0 ? 'SI' : 'NO',
        data['employeeAcceptYourSymptoms'] == 1 ? 'SI' : 'NO',
        data['employeeAcceptHomeSymptoms'] == 1 ? 'SI' : 'NO',
        data['employeeAcceptVacationSymptoms'] == 1 ? 'SI' : 'NO',
      ];
      dataToExport.add(orderedItem);
    });
    String csv =
        const ListToCsvConverter(fieldDelimiter: '|').convert(dataToExport);
    final File txtfile = await writeFileContent(csv);
    final fileUrl = await uploadFile(txtfile,
        'encuestas_${DateTime.now().millisecondsSinceEpoch.toString()}.txt');
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
