import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_create_bloc.dart';

class OutgoingTicketCreateProvider extends InheritedWidget {
  final bloc = OutgoingTicketCreateBloc();

  OutgoingTicketCreateProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static OutgoingTicketCreateBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OutgoingTicketCreateProvider>()
        .bloc;
  }
}
