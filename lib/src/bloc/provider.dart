import 'package:customers/src/bloc/user.bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  final userBloc = new UserBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().userBloc;
  }
}
