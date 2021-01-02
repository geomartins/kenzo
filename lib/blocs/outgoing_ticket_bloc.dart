import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/services/firestore_service.dart';
import '../models/ticket_model.dart';

class OutgoingTicketBloc extends Object with Validators {
  BehaviorSubject _department = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _result = new BehaviorSubject<List<TicketModel>>();

  void departmentSink(String value) {
    _department.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get department => _department.stream;
  Stream get isLoading => _isLoading.stream;
  Stream<List<TicketModel>> get result => FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((data) {
        List<TicketModel> result = [];
        data.docs.forEach((doc) {
          result.add(TicketModel.fromMap(doc.data()));
        });
        return result;
      });

  Future<void> fetchDepartment() async {
    ProfileModel profileModel = await FirestoreService().getProfileByUID();
    print(profileModel.department);
    departmentSink(profileModel.department);
  }

  void dispose() {
    _department.close();
    _result.close();
    _isLoading.close();
  }
}
