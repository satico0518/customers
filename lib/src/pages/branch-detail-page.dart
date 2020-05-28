import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    final bloc = Provider.of(context);
    return Scaffold(
      backgroundColor: _backColor,
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Branches')
                .document(bloc.shopCurrBranch.branchDocumentId)
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
                            opacity: 0.3)),
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data['branchName'],
                            style: TextStyle(fontSize: 50, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: [
                              Text(
                                'Aforo Máximo',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                              Text(
                                snapshot.data['maxCapacity'] != null
                                    ? snapshot.data['maxCapacity'].toString()
                                    : '0',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Aforo Actual',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                              Text(
                                snapshot.data['capacity'] != null
                                    ? snapshot.data['capacity'].toString()
                                    : '0',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
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
                                    fontWeight: FontWeight.bold
                                    ),
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
    );
  }

  void _setBackColor(BuildContext context, Map<String, dynamic> data) {
    var finalColor;
    final maxCapacity = data['maxCapacity'];
    final capacity = data['capacity'];
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
