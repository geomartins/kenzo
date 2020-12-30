import 'dart:io';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/models/ticket_response_model.dart';
import 'package:staff_portal/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_portal/services/storage_service.dart';

class OutgoingTicketResponseBloc extends Object with Validators {
  BehaviorSubject _ticketID = new BehaviorSubject<String>();
  BehaviorSubject _reply = new BehaviorSubject<String>();
  BehaviorSubject _images = new BehaviorSubject<List<File>>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void ticketIDSink(String value) {
    _ticketID.add(value);
  }

  void replySink(String value) {
    _reply.add(value);
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
  Stream get reply => _reply.stream;

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
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((data) {
        List<TicketResponseModel> result = [];
        data.docs.forEach((doc) {
          result.add(TicketResponseModel.fromMap(doc.data()));
        });
        return result;
      });

  List<File> validImages() {
    return _images.value ?? [];
  }

  Future<void> submit() async {
    try {
      List<String> imageURLs = await StorageService()
          .uploadFiles(images: validImages(), path: 'uploads/tickets/images');
      await FirestoreService().createOutgoingTicketResponse(
          reply: _reply.value, ticketID: _ticketID.value, imageURLs: imageURLs);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _ticketID.close();
    _reply.close();
    _images.close();
    _isLoading.close();
  }
}
