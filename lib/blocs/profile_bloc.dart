import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/services/auth_service.dart';
import 'package:staff_portal/services/firestore_service.dart';
import 'package:staff_portal/services/storage_service.dart';

class ProfileBloc extends Object with Validators {
  BehaviorSubject _profile = new BehaviorSubject<ProfileModel>();
  BehaviorSubject _image = new BehaviorSubject<File>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void profileSink(ProfileModel value) {
    _profile.sink.add(value);
  }

  void imageSink(File value) {
    _image.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get profile => _profile.stream;
  Stream get isLoading => _isLoading.stream;
  Stream get image => _image.stream;

  Future<void> fetchProfile() async {
    try {
      final result = await FirestoreService().getProfileByUID();
      profileSink(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadCover() async {
    try {
      final String downloadUrl = await StorageService()
          .uploadFile(path: 'uploads/cover', image: _image.value);
      FirestoreService().updateCoverUrl(url: downloadUrl);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _profile.close();
    _image.close();
    _isLoading.close();
  }
}
