import 'package:flutter/material.dart';

class IncomingTicket extends StatelessWidget {
  static const String id = 'incoming_ticket';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Incoming Ticket'),
        ],
      ),
    );
  }
}
