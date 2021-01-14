import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/tickets_bloc.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/components/custom_tickets_card.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/tickets_model.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/providers/tickets_provider.dart';
import 'package:staff_portal/services/auth_service.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';
import 'package:staff_portal/views/admin/opinion.dart';
import 'package:staff_portal/views/admin/profile.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket.dart';

class Dashboard extends StatelessWidget {
  static const id = 'dashboard';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Dashboard() {
    FirebaseMessagingService().topicSubscription(topic: 'ticket');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(id);
    final bloc = TicketsProvider.of(context);

    return CustomAuthBuilder(
        child: Scaffold(
      key: _drawerKey,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 100,
              child: ListView(
                children: [
                  //_buildBackIcon(context),
                  SizedBox(height: 20.0),
                  _buildTitleWithCaption(context),
                  SizedBox(height: 40.0),
                  _buildCardList(context, bloc),
                  SizedBox(height: 20.0),
                  _buildNextButton(context, bloc),
                ],
              )),
        ),
      ),
    ));
  }

  Widget _buildTitleWithCaption(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hi ${AuthService().getDisplayName(type: 'first') ?? 'Staff'}',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                )),
        SizedBox(height: 5.0),
        Text(
          'Relax while we keep an eye on your tickets',
          style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 16.0,
                color: kTertiaryColor,
              ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, TicketsBloc bloc) {
    return StreamBuilder<TicketsModel>(
        stream: bloc.selected,
        initialData: TicketsModel('incoming', IncomingTicket.id),
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomFlatButton(
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  radius: 30.0,
                  title: 'Next',
                  onPressed: !snapshot.hasData || snapshot.data == null
                      ? null
                      : () {
                          Navigator.pushNamed(
                              context, snapshot.data.selectedUrl);
                        }),
            ],
          );
        });
  }

  Widget _buildCardList(BuildContext context, TicketsBloc bloc) {
    return StreamBuilder<TicketsModel>(
        stream: bloc.selected,
        initialData: TicketsModel('incoming', IncomingTicket.id),
        builder: (context, snapshot) {
          return Wrap(
            spacing: 20.0,
            runSpacing: 45.0,
            children: [
              CustomTicketsCard(
                title: 'Incoming',
                icon: Icons.inbox_outlined,
                iconColor: snapshot.data.selectedId == 'incoming'
                    ? kPrimaryColor
                    : kTertiaryColor,
                offStage: snapshot.data.selectedId == 'incoming' ? false : true,
                onPressed: () => bloc
                    .selectedSink(TicketsModel('incoming', IncomingTicket.id)),
              ),
              CustomTicketsCard(
                title: 'Outgoing',
                icon: Icons.outbox,
                iconColor: snapshot.data.selectedId == 'outgoing'
                    ? kPrimaryColor
                    : kTertiaryColor,
                offStage: snapshot.data.selectedId == 'outgoing' ? false : true,
                onPressed: () => bloc
                    .selectedSink(TicketsModel('outgoing', OutgoingTicket.id)),
              ),
              CustomTicketsCard(
                title: 'Profile',
                icon: FontAwesome.user_o,
                iconColor: snapshot.data.selectedId == 'profile'
                    ? kPrimaryColor
                    : kTertiaryColor,
                offStage: snapshot.data.selectedId == 'profile' ? false : true,
                onPressed: () =>
                    bloc.selectedSink(TicketsModel('profile', Profile.id)),
              ),
              CustomTicketsCard(
                title: 'Feedback',
                icon: FontAwesome.feed,
                iconColor: snapshot.data.selectedId == 'feedback'
                    ? kPrimaryColor
                    : kTertiaryColor,
                offStage: snapshot.data.selectedId == 'feedback' ? false : true,
                onPressed: () =>
                    bloc.selectedSink(TicketsModel('feedback', Opinion.id)),
              ),
            ],
          );
        });
  }
}
