import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/tickets_bloc.dart';

class TicketsProvider extends InheritedWidget {
  final bloc = TicketsBloc();

  TicketsProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static TicketsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TicketsProvider>().bloc;
  }
}
