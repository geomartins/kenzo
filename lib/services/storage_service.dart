import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class StorageService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadFile({File image, String path}) async {
    String extension = p.extension(image.path);
    try {
      final storageReference =
          storage.ref().child(path).child(Uuid().v4() + extension);
      final uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      String returnURL;
      await storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
      print(returnURL);
      return returnURL;
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<List<String>> uploadFiles({List<File> images, String path}) async {
    List<String> result = [];
    for (File image in images) {
      result.add(await uploadFile(image: image, path: path));
    }
    return result;
  }
}
