import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/preference_bloc.dart';
import 'package:staff_portal/components/custom_icon_button.dart';
import 'package:staff_portal/providers/preference_provider.dart';
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
    //String routeID = ModalRoute.of(context).settings.name;
    final bloc = PreferenceProvider.of(context);
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildDashboard(bloc, context),
          _buildEvents(bloc, context),
          _buildChats(bloc, context),
          _buildProfile(bloc, context),
          _buildModule(bloc, context),
        ],
      ),
    );
  }

  Widget _buildDashboard(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
      stream: bloc.isActive,
      builder: (context, snapshot) {
        return CustomIconButton(
          icon: Icons.home,
          color: snapshot.data == 'dashboard' ? Colors.teal : Colors.grey,
          onPressed: () {
            Navigator.pushNamed(context, Dashboard.id);
          },
        );
      },
    );
  }

  Widget _buildEvents(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: Icons.timeline,
              color: snapshot.data == 'events' ? Colors.teal : Colors.grey,
              onPressed: () {
                Navigator.pushNamed(context, Events.id);
              });
        });
  }

  Widget _buildChats(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: Icons.chat_bubble_outline,
              color: snapshot.data == 'chats' ? Colors.teal : Colors.grey,
              onPressed: () {
                Navigator.pushNamed(context, Chats.id);
              });
        });
  }

  Widget _buildProfile(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: FontAwesome.user_o,
              color: snapshot.data == 'profile' ? Colors.teal : Colors.grey,
              onPressed: () {
                Navigator.pushNamed(context, Profile.id);
              });
        });
  }

  Widget _buildModule(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: Icons.menu,
              color: snapshot.data == 'module' ? Colors.teal : Colors.grey,
              onPressed: () {
                _drawerKey.currentState.openDrawer();
              });
        });
  }
}
