import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomFileViewer extends StatelessWidget {
  final String type;
  final String url;
  CustomFileViewer({this.url, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView(
            children: [_typeChecker()],
          ),
        ),
      ),
    );
  }

  Widget _typeChecker() {
    if (type == 'image') {
      return PinchZoomImage(
        image: Image.network(url),
        zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        hideStatusBarWhileZooming: true,
        onZoomStart: () {
          print('Zoom started');
        },
        onZoomEnd: () {
          print('Zoom finished');
        },
      );

      //return Image.network(url, fit: BoxFit.cover);
    }
    if (type == 'pdf') {
      return SfPdfViewer.network(url);
    }

    return Container();
  }
}
