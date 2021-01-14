import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/ticket_response_bloc.dart';

class TicketResponseProvider extends InheritedWidget {
  final bloc = TicketResponseBloc();

  TicketResponseProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static TicketResponseBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TicketResponseProvider>()
        .bloc;
  }
}
