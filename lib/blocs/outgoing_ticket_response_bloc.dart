import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/models/ticket_response_model.dart';
import 'package:staff_portal/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_portal/services/storage_service.dart';

class OutgoingTicketResponseBloc extends Object with Validators {
  //SUBJECT
  BehaviorSubject _ticketID = new BehaviorSubject<String>();
  BehaviorSubject _reply = new BehaviorSubject<String>();
  BehaviorSubject _images = new BehaviorSubject<List<File>>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _status = new BehaviorSubject<String>();
  BehaviorSubject _notifier = new BehaviorSubject<String>();
  BehaviorSubject _notifierViewId = new BehaviorSubject<String>();
  BehaviorSubject _editingControllers =
      new BehaviorSubject<List<TextEditingController>>();
  //=SUBJECT

  //SINK
  void ticketIDSink(String value) => _ticketID.add(value);
  void replySink(String value) => _reply.add(value);
  void imagesSink(List<File> value) => _images.sink.add(value);
  void loadingSink(bool value) => _isLoading.sink.add(value);
  void statusSink(String value) {
    _status.sink.add(value);
    updateStatus();
  }

  void editingControllersSink(List<TextEditingController> value) =>
      _editingControllers.sink.add(value);
  void notifierSink(String value) => _notifier.sink.add(value);
  void notifierViewIdSink(String value) => _notifierViewId.sink.add(value);
  //=SINK

  //STREAMS
  Stream get isLoading => _isLoading.stream;
  Stream get images => _images.stream;
  Stream get ticketID => _ticketID.stream;
  Stream get reply => _reply.stream;

  Stream<TicketModel> get ticketData => FirebaseFirestore.instance
          .collection('tickets')
          .doc(_ticketID.value)
          .snapshots()
          .map((data) {
        final result = TicketModel.fromMap(data.data());
        notifierSink(result.toDepartment + '_ticket_response');
        notifierViewIdSink('incoming_ticket_response');
        return result;
      });

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

  //=STREAM

  List<File> validImages() {
    return _images.value ?? [];
  }

  String get validReply => _reply.value;

  Future<void> submit() async {
    try {
      List<String> imageURLs = await StorageService()
          .uploadFiles(images: validImages(), path: 'uploads/tickets/images');
      await FirestoreService().createOutgoingTicketResponse(
        reply: _reply.value,
        ticketID: _ticketID.value,
        imageURLs: imageURLs,
        notifier: _notifier.value,
        notifierViewId: _notifierViewId.value,
      );
      clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus() async {
    try {
      FirestoreService()
          .updateTicketStatus(status: _status.value, ticketID: _ticketID.value);
    } catch (e) {
      rethrow;
    }
  }

  void clear() {
    imagesSink(null);
    _editingControllers.value[0].text = '';
  }

  void dispose() {
    _ticketID.close();
    _reply.close();
    _images.close();
    _isLoading.close();
    _notifier.close();
    _notifierViewId.close();

    _status.close();
    _editingControllers.close();
  }
}
