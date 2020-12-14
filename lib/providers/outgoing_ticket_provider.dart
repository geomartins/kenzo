import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';

class OutgoingTicketProvider extends InheritedWidget {
  final bloc = OutgoingTicketBloc();

  OutgoingTicketProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static OutgoingTicketBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OutgoingTicketProvider>()
        .bloc;
  }
}
