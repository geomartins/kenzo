import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginProvider>().bloc;
  }
}
