import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomIncomingTicketListTile extends StatelessWidget {
  final VoidCallback onPressed;
  CustomIncomingTicketListTile({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: ListTile(
          title: Text('Just paid for the hosting of Nardus.ng domain'),
          subtitle: Wrap(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.signal_wifi_4_bar_lock, color: kPrimaryColor),
                  SizedBox(width: 3.0),
                  Text('Client Services'),
                ],
              ),
              SizedBox(width: 20.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_clock, color: kPrimaryColor),
                  SizedBox(width: 3.0),
                  Text('April 16, 2020'),
                ],
              ),
            ],
          ),
          leading: CircleAvatar(
            child: Text(
              'CS',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal,
          ),
        ),
      ),
    );
  }
}
