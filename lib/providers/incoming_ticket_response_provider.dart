import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/incoming_ticket_response_bloc.dart';

class IncomingTicketResponseProvider extends InheritedWidget {
  final bloc = IncomingTicketResponseBloc();

  IncomingTicketResponseProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static IncomingTicketResponseBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IncomingTicketResponseProvider>()
        .bloc;
  }
}
