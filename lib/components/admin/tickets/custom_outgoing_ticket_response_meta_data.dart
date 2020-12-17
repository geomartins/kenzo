import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/config/constants.dart';

class CustomOutgoingTicketResponseMetaData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          'Anglican Church Suspends Bishop',
          style: TextStyle(letterSpacing: 0.7),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anglican Church Suspends Bishop Anglican Church in Suspends Bishop Anglican Church Suspends Bishop',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 5.0),
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesome.user_o, color: kPrimaryColor, size: 20.0),
                    SizedBox(width: 3.0),
                    Text(
                      'Martins Abiodun',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                SizedBox(width: 20.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_clock, color: kPrimaryColor, size: 20.0),
                    SizedBox(width: 3.0),
                    Text(
                      'April 16, 2020',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
