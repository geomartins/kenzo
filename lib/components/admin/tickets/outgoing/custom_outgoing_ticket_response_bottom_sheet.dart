import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';
import 'package:staff_portal/utilities/device_file.dart';
import '../../../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketResponseBottomSheet extends StatelessWidget
    with GetSnackbar {
  final VoidCallback cameraOnPressed;
  final VoidCallback fileOnPressed;
  final String responseType;
  final ScrollController scrollController;
  final String initialText;
  final replyController = new TextEditingController();

  CustomOutgoingTicketResponseBottomSheet(
      {this.cameraOnPressed,
      this.fileOnPressed,
      this.responseType = 'text',
      @required this.scrollController,
      this.initialText});
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketResponseProvider.of(context);
    bloc.editingControllersSink([replyController]);

    return StreamBuilder<List<File>>(
        stream: bloc.images,
        initialData: null,
        builder: (context, imagesSnapshot) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: ListView(
                reverse: true,
                children: [
                  _buildReplyFieldWithIcons(context, bloc),
                  _buildImagePreview(context, bloc, imagesSnapshot),
                ],
              ),
              width: double.infinity,
              height: imagesSnapshot.hasData
                  ? MediaQuery.of(context).size.height - 200
                  : 100,
              color: Colors.white30,
            ),
          );
        });
  }

  Widget _buildReplyFieldWithIcons(context, OutgoingTicketResponseBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Tooltip(
                message: 'File',
                child: IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    icon: Icon(
                      FontAwesome.folder_o,
                      color: kTertiaryColor,
                    ),
                    onPressed: fileOnPressed))),
        Expanded(
            flex: 6,
            child: StreamBuilder<String>(
                stream: bloc.reply,
                initialData: '',
                builder: (context, snapshot) {
                  return StreamBuilder<bool>(
                      stream: bloc.isLoading,
                      initialData: false,
                      builder: (context, isLoadingSnapshot) {
                        return TextField(
                          controller: replyController,
                          enabled: !isLoadingSnapshot.data,
                          maxLines: null,
                          onChanged: (String newValue) {
                            bloc.replySink(newValue);
                          },
                          decoration: InputDecoration(
                            hintText: 'Write a response ...',
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            suffixIcon: GestureDetector(
                              child: IconButton(
                                icon: Icon(Icons.schedule_send,
                                    color: isLoadingSnapshot.data != true &&
                                            replyController.text.length > 1
                                        ? kPrimaryColor
                                        : kTertiaryColor),
                                onPressed: isLoadingSnapshot.data != true &&
                                        replyController.text.length > 1
                                    ? () async {
                                        try {
                                          bloc.loadingSink(true);
                                          await bloc.submit();
                                          bloc.clear();
                                        } on PlatformException catch (e) {
                                          buildCustomSnackbar(
                                              titleText: 'Oops!!!',
                                              messageText: e.message,
                                              icon: Icons.error,
                                              iconColor: Colors.red);
                                        } finally {
                                          bloc.loadingSink(false);
                                          _scrollToBottom();
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(40.0),
                              ),
                            ),
                          ),
                        );
                      });
                }))
      ],
    );
  }

  Widget _buildImagePreview(
      BuildContext context,
      OutgoingTicketResponseBloc bloc,
      AsyncSnapshot<List<File>> imagesSnapshot) {
    return !imagesSnapshot.hasData || imagesSnapshot.data.length < 1
        ? Container()
        : StreamBuilder<bool>(
            stream: bloc.isLoading,
            initialData: false,
            builder: (context, isLoadingSnapshot) {
              return Column(
                children: [
                  Container(
                    color: kTertiaryColor.shade100,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(FontAwesome.close, color: kPrimaryColor),
                            onPressed: () {
                              bloc.clear();
                            }),
                        CustomOffstageProgressIndicator(
                            status: !isLoadingSnapshot.data)
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: DeviceFile().views(bloc),
                    color: kTertiaryColor.shade100,
                  ),
                ],
              );
            });
  }

  void _scrollToBottom() {
    // print(scrollController.offset);
    // double maxScroll = scrollController.position.maxScrollExtent;
    // double currentScroll = scrollController.position.pixels;
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 500.0);
  }
}
