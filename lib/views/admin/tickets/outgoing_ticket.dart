import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';
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
                  final TicketModel result = await showSearch(
                      context: context, delegate: TicketSearch(bloc.result));
                  print(result.title);
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
                      Text('ONGOING', style: TextStyle(color: Colors.black54)),
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
          body: TabBarView(
            children: [
              // _buildAllTickets(context),
              _buildTickets(context, bloc, 'opened'),
              _buildTickets(context, bloc, 'ongoing'),
              _buildTickets(context, bloc, 'closed'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTickets(
      BuildContext context, OutgoingTicketBloc bloc, String status) {
    return StreamBuilder<String>(
        stream: bloc.department,
        initialData: null,
        builder: (context, departmentSnapshot) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tickets')
                  .where('from_department', isEqualTo: departmentSnapshot.data)
                  .where('status', isEqualTo: status)
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomOutgoingTicketLoadingContainer();
                }

                return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> recievedDocument = document.data();
                  recievedDocument['id'] = document.id;

                  final ticketModel = TicketModel.fromMap(recievedDocument);
                  print(ticketModel.id);

                  return CustomOutgoingTicketListTile(
                    title: ticketModel.title,
                    department: ticketModel.toDepartment,
                    datetime: ticketModel.createdAt.toDate(),
                    onPressed: () => Navigator.pushNamed(
                        context, OutgoingTicketResponse.id,
                        arguments: ticketModel.id),
                  );
                }).toList());
              });
        });
  }
}

class TicketSearch extends SearchDelegate<TicketModel> {
  final Stream<List<TicketModel>> ticketModels;

  TicketSearch(this.ticketModels);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<TicketModel>>(
      stream: ticketModels,
      builder: (context, AsyncSnapshot<List<TicketModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data'),
          );
        }

        final results = snapshot.data.where((TicketModel a) {
          if (a.title != null) {
            return a.title.toLowerCase().contains(query);
          }
          return false;
        });
        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(
                      a.title ?? 'xxx',
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 16.0),
                    ),
                    leading: Icon(Icons.book),
                    subtitle: Text(a.description),
                    onTap: () {
                      close(context, a);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<TicketModel>>(
      stream: ticketModels,
      builder: (context, AsyncSnapshot<List<TicketModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data'),
          );
        }

        final results = snapshot.data.where((TicketModel a) {
          if (a.title != null) {
            return a.title.toLowerCase().contains(query);
          }
          return false;
        });
        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(
                      a.title ?? 'xxx',
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 16.0, color: kPrimaryColor),
                    ),
                    leading: Icon(Icons.book),
                    subtitle: Text(a.description),
                    onTap: () {
                      close(context, a);
                      //query = a.title;
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}

// return ListView.builder(
// itemCount: snapshot.data
//     .where((a) => a.title.toLowerCase().contains(query))
// .length,
// itemBuilder: (BuildContext context, int index) {
// return Text(snapshot.data[index].title ?? 'oopps');
// },
