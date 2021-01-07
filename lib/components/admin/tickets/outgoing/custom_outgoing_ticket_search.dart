import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_response.dart';
import 'custom_outgoing_ticket_list_tile.dart';

class CustomOutgoingTicketSearch extends SearchDelegate<TicketModel> {
  final OutgoingTicketBloc bloc;

  CustomOutgoingTicketSearch({this.bloc});

  @override
  String get searchFieldLabel => 'Search Ticket';

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: kTertiaryColor,
        fontSize: 16.0,
      );

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
        stream: bloc.search,
        builder: (context, AsyncSnapshot<List<TicketModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No data'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              List<TicketModel> results = snapshot.data;
              return CustomOutgoingTicketListTile(
                  title: results[index].title,
                  department: results[index].toDepartment,
                  status: results[index].status,
                  onPressed: () {
                    close(context, null);
                    Navigator.pushNamed(context, OutgoingTicketResponse.id,
                        arguments: results[index].id);
                  });
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    bloc.searchTicket(query ?? ' ');
    return StreamBuilder<List<TicketModel>>(
      stream: bloc.search,
      builder: (context, AsyncSnapshot<List<TicketModel>> snapshot) {
        print('Data ${snapshot.data}');
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data'),
          );
        }

        if (snapshot.data.length < 1) {
          return Center(
            child: Text('No data found'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            List<TicketModel> results = snapshot.data;
            return CustomOutgoingTicketListTile(
                title: results[index].title,
                department: results[index].toDepartment,
                status: results[index].status,
                onPressed: () {
                  close(context, null);
                  Navigator.pushNamed(context, OutgoingTicketResponse.id,
                      arguments: results[index].id);
                });
          },
        );
      },
    );
  }
}
