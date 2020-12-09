import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';

class StorageService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadFile({File image, String path}) async {
    try {
      final storageReference =
          storage.ref().child(path).child(auth.currentUser.uid);
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
}
