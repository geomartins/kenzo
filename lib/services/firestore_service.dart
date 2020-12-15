import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/models/profile_model.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<ProfileModel> getProfileByUID() async {
    String uid = auth.currentUser.uid;
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(uid).get();
      Map<String, dynamic> data = snapshot.data();
//      print(data);
      return ProfileModel.fromFirestore(data);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  void updatePhotoURL({String photoURL}) async {
    try {
      await auth.currentUser.updateProfile(photoURL: photoURL);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> updateCoverUrl({String url}) async {
    String uid = auth.currentUser.uid;
    try {
      await firestore.collection('users').doc(uid).update({'cover_url': url});
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }
}
