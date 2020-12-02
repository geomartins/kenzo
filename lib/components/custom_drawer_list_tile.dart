import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';

class CustomDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  CustomDrawerListTile({@required this.icon, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 10.0),
            Icon(
              icon,
              color: kPrimaryColor,
            ),
            SizedBox(width: 10.0),
            Text(title)
          ],
        ),
        Divider(),
      ],
    );
  }
}
