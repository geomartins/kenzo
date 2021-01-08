import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/services/firestore_service.dart';

class OpinionBloc extends Object with Validators {
  BehaviorSubject _description = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _editingControllers =
      new BehaviorSubject<List<TextEditingController>>();

  void descriptionSink(String value) {
    _description.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  void editingControllersSink(List<TextEditingController> value) {
    _editingControllers.sink.add(value);
  }

  Stream<String> get description =>
      _description.stream.transform(validateDescription);
  Stream get isLoading => _isLoading.stream;

  Future<void> submit() async {
    final String validDescription = _description.value;
    print(validDescription);
    await FirestoreService().createOpinion(description: validDescription);
    clear();
    try {} catch (e) {
      rethrow;
    }
  }

  void clear() {
    _editingControllers.value[0].text = '';
  }

  void dispose() {
    _description.close();
    _isLoading.close();
    _editingControllers.close();
  }
}
