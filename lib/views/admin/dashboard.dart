import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/services/auth_service.dart';

class Dashboard extends StatelessWidget {
  static const id = 'dashboard';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomAuthBuilder(
        child: Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: GestureDetector(
              child: Text('Dashboard'),
              onTap: () async {
                await AuthService().logout();
              },
            ),
          ),
        ),
      ),
    ));
  }
}
