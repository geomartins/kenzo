import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/preference_bloc.dart';
import 'package:staff_portal/components/custom_icon_button.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/admin/profile.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket.dart';

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
          _buildIncomingTicket(bloc, context),
          _buildOutgoingTicket(bloc, context),
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
          title: 'Dashboard',
          onPressed: () {
            Navigator.pushNamed(context, Dashboard.id);
          },
        );
      },
    );
  }

  Widget _buildIncomingTicket(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: Icons.inbox_outlined,
              color: snapshot.data == 'incoming_ticket'
                  ? Colors.teal
                  : Colors.grey,
              title: 'Incoming',
              onPressed: () {
                Navigator.pushNamed(context, IncomingTicket.id);
              });
        });
  }

  Widget _buildOutgoingTicket(PreferenceBloc bloc, BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.isActive,
        builder: (context, snapshot) {
          return CustomIconButton(
              icon: Icons.outbox,
              color: snapshot.data == 'outgoing_ticket'
                  ? Colors.teal
                  : Colors.grey,
              title: 'Outgoing',
              onPressed: () {
                Navigator.pushNamed(context, OutgoingTicket.id);
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
              title: 'Profile',
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
              title: 'Settings',
              onPressed: () {
                _drawerKey.currentState.openDrawer();
              });
        });
  }
}
