import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';

class PreferenceBloc extends Object with Validators {
  BehaviorSubject _isActive = new BehaviorSubject<String>();

  void activeSink(String value) {
    _isActive.sink.add(value);
  }

  Stream get isActive => _isActive.stream;

  void dispose() {
    _isActive.close();
  }
}
