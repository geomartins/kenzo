import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_file_action_buttons.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/download_service_provider.dart';

class CustomOutgoingTicketResponseMediaFrame extends StatelessWidget {
  final TicketModel data;

  const CustomOutgoingTicketResponseMediaFrame({this.data});
  @override
  Widget build(BuildContext context) {
    final dspBloc = DownloadServiceProvider.of(context);
    return data.images.length < 1
        ? Container()
        : Container(
            width: double.infinity,
            height: 300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.images.length,
              itemBuilder: (context, int index) {
                return Stack(
                  children: [
                    Container(
                      key: Key(index.toString()),
                      margin: EdgeInsets.all(10.0),
                      width: data.images.length < 2
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width / 2,
                      color: kTertiaryColor.shade200,
                      child: Image.network(
                        data.images[index.toInt()],
                        fit: BoxFit.cover,
                      ),
                    ),
                    CustomFileActionButtons(
                        dspBloc: dspBloc, url: data.images[index.toInt()]),
                  ],
                );
              },
            ),
          );
  }
}
