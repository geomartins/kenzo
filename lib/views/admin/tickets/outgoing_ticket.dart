import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_search.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_outgoing_ticket_loading_container.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_outgoing_ticket_list_tile.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/outgoing_ticket_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_create.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_response.dart';

class OutgoingTicket extends StatelessWidget {
  static const id = 'outgoing_ticket';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void dependencies(OutgoingTicketBloc bloc) async {
    await bloc.fetchDepartment();
  }

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    final bloc = OutgoingTicketProvider.of(context);
    dependencies(bloc);

    return CustomAuthBuilder(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(OutgoingTicketCreate.id);
            },
          ),
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios_outlined),
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await showSearch(
                      context: context,
                      delegate: CustomOutgoingTicketSearch(bloc.allTickets));
                },
                icon: Icon(Icons.search),
              )
              // Icon(Icons.search),
              // SizedBox(width: 20.0),
            ],
            title: Text(
              'Outgoing Tickets',
              style: TextStyle(color: Colors.black87, letterSpacing: 1.0),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: kPrimaryColor),
            bottom: TabBar(
              labelStyle: TextStyle(
                fontSize: 15.0,
              ),
              tabs: [
                Tab(
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('OPENED',
                          style: TextStyle(color: Colors.black54))),
                ),
                Tab(
                  child:
                      Text('PENDING', style: TextStyle(color: Colors.black54)),
                ),
                Tab(
                  child:
                      Text('CLOSED', style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
          key: _drawerKey,
          bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
          drawer: CustomDrawer(),
          body: StreamBuilder<String>(
              stream: bloc.department,
              initialData: null,
              builder: (context, departmentSnapshot) {
                return StreamBuilder<List<TicketModel>>(
                    stream: bloc.allTickets,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TicketModel>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomOutgoingTicketLoadingContainer();
                      }

                      final List<TicketModel> openedTickets = snapshot.data
                          .where((element) => element.status == 'opened')
                          .toList();
                      final List<TicketModel> closedTickets = snapshot.data
                          .where((element) => element.status == 'closed')
                          .toList();
                      final List<TicketModel> pendingTickets = snapshot.data
                          .where((element) => element.status == 'pending')
                          .toList();
                      return TabBarView(
                        children: [
                          _buildTickets(context, openedTickets),
                          _buildTickets(context, pendingTickets),
                          _buildTickets(context, closedTickets),
                        ],
                      );
                    });
              }),
          // body: TabBarView(
          //   children: [
          //     // _buildAllTickets(context),
          //     _buildTickets(context, bloc, 'opened'),
          //     Text('Outgoing'),
          //     Text('Closed')
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildTickets(BuildContext context, List<TicketModel> datas) {
    return ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomOutgoingTicketListTile(
            title: datas[index].title != null ? datas[index].title : 'UnknowX',
            department: datas[index].toDepartment,
            datetime: datas[index].createdAt.toDate(),
            onPressed: () => Navigator.pushNamed(
                context, OutgoingTicketResponse.id,
                arguments: datas[index].id),
          );
        });
  }
}
