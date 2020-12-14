import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/incoming_ticket_bloc.dart';

class IncomingTicketProvider extends InheritedWidget {
  final bloc = IncomingTicketBloc();

  IncomingTicketProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static IncomingTicketBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IncomingTicketProvider>()
        .bloc;
  }
}
