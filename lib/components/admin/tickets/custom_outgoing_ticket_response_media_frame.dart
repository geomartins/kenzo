import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';

class CustomOutgoingTicketResponseMediaFrame extends StatelessWidget {
  final TicketModel data;
  CustomOutgoingTicketResponseMediaFrame({@required this.data});
  @override
  Widget build(BuildContext context) {
    return data.images.length < 1
        ? Container()
        : Container(
            width: double.infinity,
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.images.length,
              itemBuilder: (context, int index) {
                return Container(
                  margin: EdgeInsets.all(10.0),
                  width: data.images.length < 2
                      ? MediaQuery.of(context).size.width
                      : 200,
                  height: 200,
                  color: kTertiaryColor.shade200,
                  child: Image.network(data.images[index], fit: BoxFit.cover),
                );
              },
            ),
          );
  }
}
