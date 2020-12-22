import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/services/firestore_service.dart';
import 'package:staff_portal/services/storage_service.dart';

class OutgoingTicketCreateBloc extends Object with Validators {
  //CONTROLLER
  BehaviorSubject _images = new BehaviorSubject<List<File>>();
  BehaviorSubject _department = new BehaviorSubject<String>();
  BehaviorSubject _departmentList = new BehaviorSubject<List<String>>();
  BehaviorSubject _title = new BehaviorSubject<String>();
  BehaviorSubject _description = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  //SINKS
  void imagesSink(List<File> value) {
    _images.sink.add(value);
  }

  void departmentSink(String value) {
    _department.sink.add(value);
  }

  void departmentListSink(List<String> value) {
    _departmentList.sink.add(value);
  }

  void titleSink(String value) {
    _title.sink.add(value);
  }

  void descriptionSink(String value) {
    _description.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  //STREAMS
  Stream get isLoading => _isLoading.stream;
  Stream get department => _department.stream;
  Stream get departmentList => _departmentList.stream;
  Stream get title => _title.stream;
  Stream get description => _description.stream;
  Stream get images => _images.stream;

  //GETTERS
  List<File> validImages() => _images.value ?? [];
  String get validTitle => _title.value;
  String get validDepartment => _department.value;
  List<String> get validDepartmentList => _departmentList.value;
  String get validDescription => _description.value;

  Stream<bool> get submitValid =>
      Rx.combineLatest3(department, title, description, (a, b, c) => true);

  //METHODS
  void fetchDepartmentList() async {
    List<String> result = await FirestoreService().getDepartmentList();
    departmentListSink(result);
  }

  Future<void> submit() async {
    try {

      List<String> imageURLs = await StorageService().uploadFiles(images: validImages(), path: 'uploads/tickets/images');
      await FirestoreService().createOutgoingTicket(
          title: validTitle,
          description: validDescription,
          toDepartment: validDepartment,
          imageURLs: imageURLs);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _images.close();
    _department.close();
    _departmentList.close();
    _title.close();
    _description.close();
    _isLoading.close();
  }

  void clear() {
    imagesSink(null);
    titleSink(' ');
    descriptionSink(' ');

  }
}
