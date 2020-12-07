import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/register_bloc.dart';

class RegisterProvider extends InheritedWidget {
  final bloc = RegisterBloc();

  RegisterProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static RegisterBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegisterProvider>().bloc;
  }
}
