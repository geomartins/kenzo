import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomOutgoingTicketResponseAppbar extends AppBar {
  final VoidCallback leadingOnPressed;

  CustomOutgoingTicketResponseAppbar({this.leadingOnPressed})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: ListTile(
            leading: CircleAvatar(
              child: Text('MA'),
              backgroundColor: kPrimaryColor,
            ),
            title: Text('Client Services'),
            subtitle: Text('2hrs'),
            trailing: Icon(Icons.attach_money_rounded),
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_outlined),
            onTap: () {
              leadingOnPressed();
            },
          ),
          leadingWidth: 10.0,
        );
}
