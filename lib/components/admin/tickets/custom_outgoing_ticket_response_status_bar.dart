import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomOutgoingTicketResponseStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: kTertiaryColor.shade400),
          bottom: BorderSide(width: 1.0, color: kTertiaryColor.shade400),
        ),
      ),
      height: 40.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesome.heart_o, color: kTertiaryColor),
              SizedBox(width: 5.0),
              Text(
                'Open',
                style: TextStyle(color: kTertiaryColor),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesome.heart_o, color: kTertiaryColor),
              SizedBox(width: 5.0),
              Text(
                'In Progress',
                style: TextStyle(color: kTertiaryColor),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesome.heart_o, color: kTertiaryColor),
              SizedBox(width: 5.0),
              Text(
                'Closed',
                style: TextStyle(color: kTertiaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
