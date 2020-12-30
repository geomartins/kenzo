import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/models/ticket_model.dart';

class CustomOutgoingTicketResponseStatusBar extends StatelessWidget {
  final TicketModel data;
  CustomOutgoingTicketResponseStatusBar({@required this.data})
      : assert(data != null);

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
              Icon(
                  data.status == 'opened'
                      ? FontAwesome.heart
                      : FontAwesome.heart_o,
                  color:
                      data.status == 'opened' ? kPrimaryColor : kTertiaryColor),
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
              Icon(
                  data.status == 'in-progress'
                      ? FontAwesome.heart
                      : FontAwesome.heart_o,
                  color: data.status == 'in-progress'
                      ? kPrimaryColor
                      : kTertiaryColor),
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
              Icon(
                  data.status == 'closed'
                      ? FontAwesome.heart
                      : FontAwesome.heart_o,
                  color:
                      data.status == 'closed' ? kPrimaryColor : kTertiaryColor),
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
