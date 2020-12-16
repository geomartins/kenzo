import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/preference_provider.dart';

class OutgoingTicketResponse extends StatelessWidget {
  static const id = 'outgoing_ticket_response';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    print('In');

    return Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
      drawer: CustomDrawer(),
      appBar: AppBar(
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
            Navigator.of(context).pop();
          },
        ),
        leadingWidth: 10.0,
      ),
      bottomSheet: _buildBottomSheet(context),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 10.0),
            _buildTitleWithSubtitleAndMetaData(),
            _buildFrame(),
            _buildStatusBar(),
            SizedBox(height: 10.0),
            _buildComment(context),
            _buildComment(context),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: GestureDetector(
                          child: Tooltip(
                            waitDuration: Duration(milliseconds: 1),
                            message: 'Camera',
                            child: Icon(
                              FontAwesome.camera,
                              size: 20.0,
                              color: kTertiaryColor,
                            ),
                          ),
                          onTap: () {})),
                  Expanded(
                      child: GestureDetector(
                          child: Tooltip(
                            message: 'Gallery',
                            child: Icon(
                              FontAwesome.folder_o,
                              color: kTertiaryColor,
                            ),
                          ),
                          onTap: () {}))
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a response ...',
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    suffixIcon: Icon(Icons.schedule_send),
                    border: new OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(40.0),
                      ),
                    ),
                  ),
                ))
          ],
        ),
        width: double.infinity,
        height: 70.0,
        color: Colors.white30,
      );
  Widget _buildFrame() {
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

  Widget _buildTitleWithSubtitleAndMetaData() {
    return ListTile(
        title: Text(
          'Anglican Church Suspends Bishop',
          style: TextStyle(letterSpacing: 0.7),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anglican Church Suspends Bishop Anglican Church in Suspends Bishop Anglican Church Suspends Bishop',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 5.0),
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesome.user_o, color: kPrimaryColor, size: 20.0),
                    SizedBox(width: 3.0),
                    Text(
                      'Martins Abiodun',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                SizedBox(width: 20.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_clock, color: kPrimaryColor, size: 20.0),
                    SizedBox(width: 3.0),
                    Text(
                      'April 16, 2020',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildStatusBar() {
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

  Widget _buildComment(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('MA'),
        backgroundColor: kPrimaryColor,
      ),
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kTertiaryColor.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Martins Abiodun',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 15.0,
                  ),
            ),
            _buildFrame(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5.0),
                Text(
                  '2020-04-51 8am',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: kTertiaryColor.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
