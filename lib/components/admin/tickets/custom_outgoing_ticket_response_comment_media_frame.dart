import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_response_model.dart';

class CustomOutgoingTicketResponseCommentMediaFrame extends StatefulWidget {
  final TicketResponseModel data;
  CustomOutgoingTicketResponseCommentMediaFrame({@required this.data});

  @override
  _CustomOutgoingTicketResponseCommentMediaFrameState createState() =>
      _CustomOutgoingTicketResponseCommentMediaFrameState();
}

class _CustomOutgoingTicketResponseCommentMediaFrameState
    extends State<CustomOutgoingTicketResponseCommentMediaFrame> {
  final transformationController = TransformationController();
  @override
  Widget build(BuildContext context) {
    return widget.data.images.length < 1
        ? Container()
        : Container(
            width: double.infinity,
            height: 300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.data.images.length,
              itemBuilder: (context, int index) {
                return Container(
                  key: Key(index.toString()),
                  margin: EdgeInsets.all(10.0),
                  width: widget.data.images.length < 2
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2,
                  height: 200,
                  color: kTertiaryColor.shade200,
                  child: InteractiveViewer(
                    transformationController:
                        transformationController, // pass the transformation controller
                    onInteractionEnd: (details) {
                      setState(() {
                        transformationController.toScene(Offset
                            .zero); // return to normal size after scaling has ended
                      });
                    },
                    boundaryMargin: EdgeInsets.all(20.0),
                    minScale: 0.1, // min scale
                    maxScale: 4.6, // max scale
                    scaleEnabled: true,
                    panEnabled: true,
                    child: Image.network(
                      widget.data.images[index.toInt()],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
  }
}
