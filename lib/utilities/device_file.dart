import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:mime/mime.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'dart:io';

class DeviceFile with GetSnackbar {
  Future<void> openFiles(
      bloc, context, List<String> extensions, Function next) async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
      //allowedExtensions: extensions ?? ['jpg', 'pdf', 'doc', 'jpeg'],
    );
    if (files != null) {
      bloc.imagesSink(files);
      if (next != null) {
        next(context, bloc);
      }
    } else {
      buildCustomSnackbar(
          messageText: 'No Asset selected',
          titleText: "Oops",
          iconColor: Colors.red,
          icon: Icons.error);
    }
  }

  Widget views(bloc) {
    return StreamBuilder<List<File>>(
        stream: bloc.images,
        builder: (context, snap) {
          return Container(
            height: snap.data != null ? 200.0 : 0.0,
            child: StreamBuilder<List<File>>(
              stream: bloc.images,
              initialData: [],
              builder: (BuildContext context, snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data != null) {
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 200,
                          color: kTertiaryColor.shade200,
                          child: _isImage(snapshot.data[index]) == true
                              ? Image.file(snapshot.data[index],
                                  fit: BoxFit.cover)
                              : Image.asset(kDefaultFileUrl, fit: BoxFit.cover),
                        );
                      }
                      return Text('No File');
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        });
  }

  bool _isImage(File data) {
    final x = lookupMimeType(data.path, headerBytes: [0xFF, 0xD8]);
    String extension = '.' + x.split('/')[1];

    if (extension.contains('png') ||
        extension.contains('jpeg') ||
        extension.contains('gif') ||
        extension.contains('jpg')) {
      return true;
    } else {
      return false;
    }
  }
}
