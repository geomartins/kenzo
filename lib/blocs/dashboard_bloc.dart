import 'dart:async';
import 'package:rxdart/rxdart.dart';

class DashboardBloc extends Object {
  BehaviorSubject _isApproved = new BehaviorSubject<String>();

  // SINKS
  void isApprovedSink(String value) {
    _isApproved.sink.add(value);
  }

  //STREAMS
  Stream get isApproved => _isApproved.stream;

  void dispose() {
    _isApproved.close();
  }
}
