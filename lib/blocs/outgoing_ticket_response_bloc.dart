import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/models/ticket_response_model.dart';
import 'package:staff_portal/services/firestore_service.dart';

class OutgoingTicketResponseBloc extends Object with Validators {
  BehaviorSubject _ticketID = new BehaviorSubject<String>();
  BehaviorSubject _images = new BehaviorSubject<List<File>>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void ticketIDSink(String value) {
    _ticketID.add(value);
  }

  void imagesSink(List<File> value) {
    _images.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  //STREAMS
  Stream get isLoading => _isLoading.stream;
  Stream get images => _images.stream;
  Stream get ticketID => _ticketID.stream;

  Stream<TicketModel> get ticketData => FirebaseFirestore.instance
      .collection('tickets')
      .doc(_ticketID.value)
      .snapshots()
      .map((data) => TicketModel.fromMap(data.data()));

  Stream<List<TicketResponseModel>> get ticketResponseData =>
      FirebaseFirestore.instance
          .collection('tickets')
          .doc(_ticketID.value)
          .collection('responses')
          .snapshots()
          .map((data) {
        List<TicketResponseModel> ticketResponseModelList = [];
        for (final x in data.docs) {
          ticketResponseModelList.add(TicketResponseModel.fromMap(x.data()));
        }
        return ticketResponseModelList;
      });


  List<File> validImages() {
    return _images.value ?? [];
  }

  void dispose() {
    _ticketID.close();
    _images.close();
    _isLoading.close();
  }
}
