import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';

class OutgoingTicketCreateBloc extends Object with Validators {
  BehaviorSubject _images = new BehaviorSubject<List<File>>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void imagesSink(List<File> value) {
    _images.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get isLoading => _isLoading.stream;
  Stream get images => _images.stream;

  List<File> validImages() {
    return _images.value ?? [];
  }

  void dispose() {
    _images.close();
    _isLoading.close();
  }

  void clear() {
    imagesSink(null);
  }
}
