import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:intl/intl.dart';

class CustomOutgoingTicketListTile extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String department;
  final datetime;

  CustomOutgoingTicketListTile(
      {@required this.onPressed,
      this.title = 'Not Available',
      this.department = 'Unknown',
      this.datetime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: ListTile(
          title: Text(title ?? 'fffhf'),
          subtitle: Wrap(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.signal_wifi_4_bar_lock, color: kPrimaryColor),
                  SizedBox(width: 3.0),
                  Text(department ?? 'Unknown department'),
                ],
              ),
              SizedBox(width: 20.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_clock, color: kPrimaryColor),
                  SizedBox(width: 3.0),
                  Text(DateFormat.yMMMEd().format(datetime)),
                ],
              ),
            ],
          ),
          leading: CircleAvatar(
            child: Text(
              department != null
                  ? department.substring(0, 2).toUpperCase()
                  : 'Unknown',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal,
          ),
        ),
      ),
    );
  }

  String humanReadable() {
    int timeInMillis = datetime;
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }
}
