import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/models/tickets_model.dart';

class TicketsBloc extends Object {
  BehaviorSubject _selected = new BehaviorSubject<TicketsModel>();

  void selectedSink(TicketsModel value) {
    _selected.sink.add(value);
  }

  Stream get selected => _selected.stream;

  void dispose() {
    _selected.close();
  }
}
