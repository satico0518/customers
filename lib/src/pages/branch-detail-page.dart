import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class BranchDetail extends StatefulWidget {
  static final String routeName = 'branchdetail';
  const BranchDetail({Key key}) : super(key: key);

  @override
  _BranchDetailState createState() => _BranchDetailState();
}

class _BranchDetailState extends State<BranchDetail> {
  Color _backColor;

  @override
  Widget build(BuildContext context) {
    final _shopBloc = Provider.shopBloc(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: _backColor,
        body: Center(
          child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('Branches')
                  .document(_shopBloc.shopCurrBranch.branchDocumentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _setBackColor(context, snapshot.data.data);
                  return Stack(
                    children: [
                      Center(
                        child: Opacity(
                            child: Image(
                              image: AssetImage(
                                'assets/img/icon.png',
                              ),
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            opacity: 0.3),
                      ),
                      Positioned(
                        top: 20,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data['branchName'],
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Aforo Máximo',
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    snapshot.data['maxCapacity'] != null
                                        ? snapshot.data['maxCapacity']
                                            .toString()
                                        : '0',
                                    style: TextStyle(
                                        fontSize: 90,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Aforo Actual',
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    snapshot.data['capacity'] != null
                                        ? snapshot.data['capacity'].toString()
                                        : '0',
                                    style: TextStyle(
                                        fontSize: 120,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  getFormatedDate(DateTime.now()),
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                                Text(
                                  'PaseYa',
                                  style: GoogleFonts.acme(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error.toString()}");
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }

  void _setBackColor(BuildContext context, Map<String, dynamic> data) {
    if (data['maxCapacity'] == null || data['maxCapacity'] == 0) {
      Fluttertoast.showToast(
        msg: 'Debe asignar el aforo máximo a la sucursal ${data['branchName']}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      ).then((value) => Navigator.of(context).pop());
    }
    var finalColor;
    final maxCapacity = data['maxCapacity'];
    final capacity = data['capacity'] ?? 0;
    final currentPercentage = (capacity * 100) / maxCapacity;
    if (currentPercentage < 80) {
      finalColor = Theme.of(context).secondaryHeaderColor;
    } else if (currentPercentage >= 80 && currentPercentage < 99) {
      finalColor = Colors.orangeAccent;
    } else
      finalColor = Colors.redAccent;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() => _backColor = finalColor);
    });
  }
}
