import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/password_reset_bloc.dart';

class PasswordResetProvider extends InheritedWidget {
  final bloc = PasswordResetBloc();

  PasswordResetProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static PasswordResetBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PasswordResetProvider>()
        .bloc;
  }
}
