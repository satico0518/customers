import 'package:customers/src/bloc/form.bloc.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final userBloc = new UserBloc();
  final _formBloc = new FormBloc();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().userBloc;
  }

  static FormBloc formBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._formBloc;
  }
}
