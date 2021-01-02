import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_response.dart';
import '../../custom_outgoing_ticket_list_tile.dart';

class CustomOutgoingTicketSearch extends SearchDelegate<TicketModel> {
  final Stream<List<TicketModel>> ticketModels;
  List<TicketModel> resultList = [];

  CustomOutgoingTicketSearch(this.ticketModels);

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
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomOutgoingTicketListTile(
            title: resultList[index].title,
            department: resultList[index].toDepartment,
            datetime: resultList[index].createdAt.toDate(),
            onPressed: () {
              close(context, null);
              Navigator.pushNamed(context, OutgoingTicketResponse.id,
                  arguments: resultList[index].id);
            });
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
            return a.title.toLowerCase().contains(query.toLowerCase());
          }
          return false;
        }).toList();
        resultList = results;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomOutgoingTicketListTile(
                title: results[index].title,
                department: results[index].toDepartment,
                datetime: results[index].createdAt.toDate(),
                onPressed: () {
                  print(results[index].id);
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
