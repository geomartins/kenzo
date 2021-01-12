import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staff_portal/blocs/download_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storage_path/storage_path.dart';
import 'package:uuid/uuid.dart';

class DownloadService with GetSnackbar {
  final DownloadServiceBloc bloc;
  final String url;

  DownloadService({@required this.bloc, @required this.url});

  Dio dio = new Dio();
  Future<void> download() async {
    bloc.loadingSink(true);
    try {
      var dir = await getExternalStorageDirectory();
      Response response = await dio
          .download(this.url, "${dir.path}/${Uuid().v4()}",
              onReceiveProgress: (rec, total) {
        print('Recieved: $rec  ......... Total: $total');
        final String progress = ((rec / total) * 100).toStringAsFixed(0) + '%';
        bloc.progressSink(progress);
        print(progress);
      });

      print('${dir.path}/myimage.jpg');
      final imagePath = await StoragePath.filePath;
      print('Image List: $imagePath');
      // final result =
      //     await FolderFileSaver.saveImage(pathImage: '${dir.path}/myimage.jpg');
      // print(result);

      ///OpenFile.open("${dir.path}/myimage.jpg");
      print(response);
    } catch (e) {
      print(e);
    } finally {
      bloc.loadingSink(false);
    }
  }

  downloadX() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir.path,
        fileName: "download",
        showNotification: true,
        openFileFromNotification: true,
      );

      print('IDDDDDDDDDDDD $id');
      final imagePath = await StoragePath.filePath;
      print('Image List: $imagePath');
      buildCustomSnackbar(
          titleText: 'In Progress!!!',
          messageText: 'Download Already started at the background',
          icon: Icons.info,
          iconColor: kPrimaryColor);
    } else {
      buildCustomSnackbar(
          titleText: 'Oops!!!',
          messageText: 'Permission not granted',
          icon: Icons.error,
          iconColor: Colors.red);
    }
  }
}
