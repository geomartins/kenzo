import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:staff_portal/services/auth_service.dart';
import 'package:staff_portal/services/firestore_service.dart';

class OutgoingTicketBloc extends Object with Validators {
  BehaviorSubject _department = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void departmentSink(String value) {
    _department.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream get department => _department.stream;
  Stream get isLoading => _isLoading.stream;

  Future<void> fetchDepartment() async {
    ProfileModel profileModel = await FirestoreService().getProfileByUID();
    print(profileModel.department);
    departmentSink(profileModel.department);
  }

  void dispose() {
    _department.close();
    _isLoading.close();
  }
}
