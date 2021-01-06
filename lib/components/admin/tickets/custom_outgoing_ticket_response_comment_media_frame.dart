import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_response_model.dart';

class CustomOutgoingTicketResponseCommentMediaFrame extends StatelessWidget {
  final TicketResponseModel data;
  CustomOutgoingTicketResponseCommentMediaFrame({@required this.data});
  final transformationController = TransformationController();
  @override
  Widget build(BuildContext context) {
    return data.images.length < 1
        ? Container()
        : Container(
            width: double.infinity,
            height: 300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.images.length,
              itemBuilder: (context, int index) {
                return Container(
                  key: Key(index.toString()),
                  margin: EdgeInsets.all(10.0),
                  width: data.images.length < 2
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2,
                  height: 200,
                  color: kTertiaryColor.shade200,
                  child: GestureDetector(
                    onTap: () {
                      // print('Open this');
                      // OpenFile.open(data.images[index.toInt()]);
                    },
                    child: Image.network(
                      data.images[index.toInt()],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
  }
}
