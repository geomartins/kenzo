import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/opinion_bloc.dart';

class OpinionProvider extends InheritedWidget {
  final bloc = OpinionBloc();

  OpinionProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static OpinionBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OpinionProvider>().bloc;
  }
}
