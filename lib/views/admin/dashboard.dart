import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/config/constants.dart';

class Dashboard extends StatelessWidget {
  static const id = 'dashboard';

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text('Dashboard'),
          ),
        ),
      ),
    );
  }
}
