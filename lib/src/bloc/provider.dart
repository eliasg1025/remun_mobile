import 'package:flutter/material.dart';
import 'package:remun_mobile/src/bloc/login_bloc.dart';
import 'package:remun_mobile/src/bloc/search_bloc.dart';

export 'package:remun_mobile/src/bloc/login_bloc.dart';
export 'package:remun_mobile/src/bloc/search_bloc.dart';

class Provider extends InheritedWidget
{
  final loginBloc = LoginBloc();
  final searchBloc = SearchBloc();

  Provider({ Key key, Widget child })
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static SearchBloc ofS(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().searchBloc;
  }
}