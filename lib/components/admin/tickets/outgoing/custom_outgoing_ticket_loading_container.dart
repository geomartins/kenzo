import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomOutgoingTicketLoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          color: kTertiaryColor.shade200,
          height: 10.0,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                color: kTertiaryColor.shade200,
                height: 10.0,
                width: double.infinity,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Container(
                color: kTertiaryColor.shade200,
                height: 10.0,
                width: double.infinity,
              ),
            )
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: kTertiaryColor.shade200,
        ),
      ),
    );
  }
}
