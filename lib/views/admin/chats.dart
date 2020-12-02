import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';

class Chats extends StatelessWidget {
  static const id = 'chats';
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('Chats Page'),
      ),
    );
  }
}
