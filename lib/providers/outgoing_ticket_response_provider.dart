import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';

class OutgoingTicketResponseProvider extends InheritedWidget {
  final bloc = OutgoingTicketResponseBloc();

  OutgoingTicketResponseProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static OutgoingTicketResponseBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OutgoingTicketResponseProvider>()
        .bloc;
  }
}
