import 'package:customers/src/bloc/form.bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final formBloc = FormBloc();

  Provider({Key key, Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FormBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().formBloc;
  }
}
