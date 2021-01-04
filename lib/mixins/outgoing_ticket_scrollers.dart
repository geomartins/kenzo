import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';

class OutgoingTicketScrollers {
  final ScrollController openedTicketsScrollController = new ScrollController();
  final ScrollController closedTicketsScrollController = new ScrollController();
  final ScrollController pendingTicketsScrollController =
      new ScrollController();

  openedTicketsScroller(context, OutgoingTicketBloc bloc) {
    openedTicketsScrollController.addListener(() {
      double maxScroll = openedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = openedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchOpenedTickets(perPage: 2, more: true);
      }
    });
  }

  closedTicketsScroller(context, OutgoingTicketBloc bloc) {
    closedTicketsScrollController.addListener(() {
      double maxScroll = closedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = closedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchClosedTickets(perPage: 2, more: true);
      }
    });
  }

  pendingTicketsScroller(context, OutgoingTicketBloc bloc) {
    pendingTicketsScrollController.addListener(() {
      double maxScroll =
          pendingTicketsScrollController.position.maxScrollExtent;
      double currentScroll = pendingTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchPendingTickets(perPage: 2, more: true);
      }
    });
  }
}
