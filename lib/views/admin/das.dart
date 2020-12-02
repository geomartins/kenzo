//import 'package:flutter/material.dart';
//
//class Dashboard extends StatefulWidget {
//  static const id = 'dashboard';
//
//  @override
//  _DashboardState createState() => _DashboardState();
//}
//
//class _DashboardState extends State<Dashboard> {
//  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: _drawerKey,
//      bottomNavigationBar: BottomAppBar(
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Icon(
//              Icons.home,
//              size: 35.0,
//            ),
//            Icon(
//              Icons.report_off,
//              size: 35.0,
//            ),
//            Icon(
//              Icons.report_off,
//              size: 35.0,
//            ),
//            Icon(
//              Icons.report_off,
//              size: 35.0,
//            ),
//            CustomIconButton(
//              drawerKey: _drawerKey,
//            ),
//          ],
//        ),
//      ),
//      drawer: FractionallySizedBox(
//        child: Drawer(),
//        widthFactor: .5,
//      ),
//      body: SingleChildScrollView(
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          child: Center(
//            child: Text('Hello World'),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class CustomIconButton extends StatelessWidget {
//  final drawerKey;
//
//  const CustomIconButton({
//    Key key,
//    this.drawerKey,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        IconButton(
//            color: Colors.teal,
//            icon: Icon(
//              Icons.menu,
//              size: 35.0,
//            ),
//            onPressed: () {
//              drawerKey.currentState.openDrawer();
//            })
//      ],
//    );
//  }
//}
