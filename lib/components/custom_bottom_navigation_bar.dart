import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/views/admin/chats.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/admin/events.dart';
import 'package:staff_portal/views/admin/profile.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key key,
    @required GlobalKey<ScaffoldState> drawerKey,
  })  : _drawerKey = drawerKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _drawerKey;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomIconButton(
            icon: Icons.home,
            dynamicRouteName: ModalRoute.of(context).settings.name,
            onPressed: () {
              Navigator.pushNamed(context, Dashboard.id);
            },
          ),
          CustomIconButton(
            icon: Icons.timeline,
            onPressed: () => Navigator.pushNamed(context, Events.id),
          ),
          CustomIconButton(
            icon: Icons.chat_bubble_outline,
            onPressed: () => Navigator.pushNamed(context, Chats.id),
          ),
          CustomIconButton(
            icon: FontAwesome.user_o,
            onPressed: () => Navigator.pushNamed(context, Profile.id),
          ),
          CustomIconButton(
            icon: Icons.menu,
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String dynamicRouteName;

  const CustomIconButton({this.icon, this.onPressed, this.dynamicRouteName});

  @override
  Widget build(BuildContext context) {
    bool active = false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          color: dynamicRouteName == 'dashboard' ? Colors.teal : Colors.grey,
          icon: Icon(
            icon,
            size: 25.0,
          ),
          onPressed: () {
            active = true;
            onPressed();
          },
        ),
      ],
    );
  }
}
