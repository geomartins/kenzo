import 'package:flutter/material.dart';
import 'custom_drawer_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            CustomDrawerListTile(
                title: 'Contact History', icon: Icons.attach_file),
            CustomDrawerListTile(title: 'Graduate Trainee', icon: Icons.people),
            CustomDrawerListTile(title: 'Weekly Report', icon: Icons.bookmark),
            CustomDrawerListTile(
                title: 'Support Team', icon: Icons.accessibility_new),
            CustomDrawerListTile(title: 'Voting System', icon: Icons.palette),
          ],
        ),
      ),
      widthFactor: .5,
    );
  }
}
