import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'dart:io';

class Camera with GetSnackbar {
  Future<void> openCameraDevice(bloc, context, Function next) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      List<File> testImg = [];
      testImg.add(File(pickedFile.path));
      for (File x in bloc.validImages()) {
        testImg.add(x);
      }
      bloc.imagesSink(testImg);

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
                          child: Image.file(snapshot.data[index],
                              fit: BoxFit.cover),
                        );
                      }
                      return Text('No Image');
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
}
