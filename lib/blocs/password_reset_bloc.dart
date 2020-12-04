import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:staff_portal/services/auth_service.dart';

class PasswordResetBloc extends Object with Validators {
  BehaviorSubject _email = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void emailSink(String value) {
    _email.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream get isLoading => _isLoading.stream;

  Future<void> submit() async {
    final String validEmail = _email.value;
    try {
      await AuthService().passwordReset(validEmail);
    } catch (e) {
      rethrow;
    }
  }

//  //Change Data
//  Function(String) get changeEmail => _email.sink.add;
//  Function(String) get changePassword => _password.sink.add;

  void dispose() {
    _email.close();
    _isLoading.close();
  }
}
