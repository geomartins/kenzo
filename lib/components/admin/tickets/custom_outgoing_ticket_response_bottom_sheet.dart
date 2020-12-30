import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';

class CustomOutgoingTicketResponseBottomSheet extends StatelessWidget {
  final VoidCallback cameraOnPressed;
  final VoidCallback fileOnPressed;
  final String responseType;
  final replyController = new TextEditingController();
  final ScrollController scrollController;

  CustomOutgoingTicketResponseBottomSheet(
      {this.cameraOnPressed,
      this.fileOnPressed,
      this.responseType = 'text',
      this.scrollController});
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketResponseProvider.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcons(),
          Expanded(
              flex: 6,
              child: TextField(
                controller: replyController,
                maxLines: null,
                onChanged: (String newValue) {
                  bloc.replySink(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Write a response ...',
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.schedule_send),
                    onTap: () async {
                      await bloc.submit();
                      replyController.clear();
                      scrollController.jumpTo(
                          scrollController.position.maxScrollExtent + 500.0);
                      // print(scrollController);
                      // print(MediaQuery.of(context).size.height + 300.0);
                      // print(scrollController.position.maxScrollExtent);
                    },
                  ),
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(40.0),
                    ),
                  ),
                ),
              ))
        ],
      ),
      width: double.infinity,
      height: 100.0,
      color: Colors.white30,
    );
  }

  Widget _buildIcons() {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAddMoreIcon(responseType),
        _buildCameraIcon(responseType),
        _buildFileIcon(responseType)
      ],
    ));
  }

  Widget _buildAddMoreIcon(String responseT) {
    return responseT == 'camera' || responseT == 'file'
        ? Expanded(
            child: GestureDetector(
            child: Tooltip(
              waitDuration: Duration(milliseconds: 1),
              message: 'Add More',
              child: Icon(
                FontAwesome.plus_square,
                size: 25.0,
                color: kTertiaryColor,
              ),
            ),
            onTap: () {
              responseType == 'camera' ? cameraOnPressed() : fileOnPressed();
              print('Add More $responseT');
            },
          ))
        : Container();
  }

  Widget _buildCameraIcon(String responseT) {
    return responseT == 'text'
        ? Expanded(
            child: GestureDetector(
            child: Tooltip(
              waitDuration: Duration(milliseconds: 1),
              message: 'Camera',
              child: Icon(
                FontAwesome.camera,
                size: 20.0,
                color: kTertiaryColor,
              ),
            ),
            onTap: () {
              print('Camera Pressed');
              cameraOnPressed();
            },
          ))
        : Container();
  }

  Widget _buildFileIcon(String responseT) {
    return responseT == 'text'
        ? Expanded(
            child: GestureDetector(
                child: Tooltip(
                  message: 'File',
                  child: Icon(
                    FontAwesome.folder_o,
                    color: kTertiaryColor,
                  ),
                ),
                onTap: () => fileOnPressed))
        : Container();
  }
}
