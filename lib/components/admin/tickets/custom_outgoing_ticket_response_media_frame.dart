import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomOutgoingTicketResponseMediaFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            width: 100,
            height: 200,
            color: kTertiaryColor.shade200,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            width: 100,
            height: 200,
            color: kTertiaryColor.shade200,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            width: 100,
            height: 200,
            color: kTertiaryColor.shade200,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            width: 100,
            height: 200,
            color: kTertiaryColor.shade200,
          ),
        ],
      ),
    );
  }
}
