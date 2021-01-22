import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/incoming_ticket_bloc.dart';

class IncomingTicketScrollers {
  final ScrollController openedTicketsScrollController = new ScrollController();
  final ScrollController closedTicketsScrollController = new ScrollController();
  final ScrollController pendingTicketsScrollController =
      new ScrollController();

  openedTicketsScroller(context, IncomingTicketBloc bloc) {
    openedTicketsScrollController.addListener(() {
      double maxScroll = openedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = openedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchOpenedTickets(more: true);
      }
    });
  }

  closedTicketsScroller(context, IncomingTicketBloc bloc) {
    closedTicketsScrollController.addListener(() {
      double maxScroll = closedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = closedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchClosedTickets(more: true);
      }
    });
  }

  pendingTicketsScroller(context, IncomingTicketBloc bloc) {
    pendingTicketsScrollController.addListener(() {
      double maxScroll =
          pendingTicketsScrollController.position.maxScrollExtent;
      double currentScroll = pendingTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchPendingTickets(more: true);
      }
    });
  }
}
