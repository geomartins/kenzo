import 'package:flutter/material.dart';
import 'package:staff_portal/services/download_service.dart';
import 'custom_file_viewer.dart';

class CustomFileActionButtons extends StatelessWidget {
  final String url;
  final dspBloc;
  CustomFileActionButtons({this.url, this.dspBloc});
  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          _buildDownloadBox(),
          SizedBox(width: 5.0),
          _buildPreviewBox(context),
        ],
      ),
      bottom: 20.0,
      start: 20.0,
    );
  }

  Widget _buildDownloadBox() {
    return GestureDetector(
      onTap: () async {
        print(url);
        DownloadService(url: url, bloc: dspBloc).downloadX();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Icon(Icons.cloud_download),
        padding: EdgeInsets.all(5.0),
      ),
    );
  }

  Widget _buildPreviewBox(BuildContext context) {
    if (url.contains('jpg') ||
        url.contains('jpeg') ||
        url.contains('png') ||
        url.contains('gif')) {
      return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomFileViewer(
                        url: url,
                        type: 'image',
                      )));
        },
        child: Container(
          child: Icon(Icons.remove_red_eye_outlined),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          padding: EdgeInsets.all(5.0),
        ),
      );
    }

    if (url.contains('pdf')) {
      return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomFileViewer(
                        url: url,
                        type: 'pdf',
                      )));
        },
        child: Container(
          child: Icon(Icons.remove_red_eye_outlined),
          color: Colors.white,
          padding: EdgeInsets.all(5.0),
        ),
      );
    }

    return Container();
  }
}
