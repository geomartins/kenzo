import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomOutgoingTicketResponseBottomSheet extends StatelessWidget {
  final VoidCallback cameraOnPressed;
  final VoidCallback fileOnPressed;
  final String responseType;

  CustomOutgoingTicketResponseBottomSheet(
      {this.cameraOnPressed, this.fileOnPressed, this.responseType = 'text'});
  @override
  Widget build(BuildContext context) {
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
                decoration: InputDecoration(
                  hintText: 'Write a response ...',
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  suffixIcon: Icon(Icons.schedule_send),
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
      height: 70.0,
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
