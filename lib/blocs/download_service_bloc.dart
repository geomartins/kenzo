import 'dart:async';
import 'package:rxdart/rxdart.dart';

class DownloadServiceBloc extends Object {
  BehaviorSubject _progress = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  // SINKS
  void progressSink(String value) {
    _progress.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  //STREAMS
  Stream get email => _progress.stream;

  Stream get isLoading => _isLoading.stream;

  void dispose() {
    _progress.close();
    _isLoading.close();
  }
}
