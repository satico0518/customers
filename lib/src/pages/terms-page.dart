import 'package:customers/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TermsPage extends StatelessWidget {
  static final String routeName = 'terms';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Términos y condiciones'),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * .9,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Flexible(
              child: Text(
                getTermsAndConditionsText(),
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
