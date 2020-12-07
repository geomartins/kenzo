import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/services/auth_service.dart';

class RegisterBloc extends Object with Validators {
  BehaviorSubject _firstname = new BehaviorSubject<String>();
  BehaviorSubject _middlename = new BehaviorSubject<String>();
  BehaviorSubject _lastname = new BehaviorSubject<String>();

  BehaviorSubject _email = new BehaviorSubject<String>();
  BehaviorSubject _password = new BehaviorSubject<String>();

  BehaviorSubject _isLoading = new BehaviorSubject<bool>();
  BehaviorSubject _passwordVisibility = new BehaviorSubject<bool>();

  void firstnameSink(String value) {
    _firstname.sink.add(value);
  }

  void middlenameSink(String value) {
    _middlename.sink.add(value);
  }

  void lastnameSink(String value) {
    _lastname.sink.add(value);
  }

  void emailSink(String value) {
    _email.sink.add(value);
  }

  void passwordSink(String value) {
    _password.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  void passwordVisibilitySink(bool value) {
    _passwordVisibility.sink.add(value);
  }

  Stream<String> get firstname =>
      _firstname.stream.transform(validateFirstname);
  Stream<String> get middlename =>
      _firstname.stream.transform(validateMiddlename);
  Stream<String> get lastname => _firstname.stream.transform(validateLastname);

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream get isLoading => _isLoading.stream;
  Stream get passwordVisibility => _passwordVisibility.stream;

  Stream<bool> get submitValid => Rx.combineLatest5(firstname, middlename,
      lastname, email, password, (f, m, l, e, p) => true);

  Future<void> submit() async {
    final String validFirstname = _firstname.value;
    final String validMiddlename = _middlename.value;
    final String validLastname = _lastname.value;
    final String validEmail = _email.value;
    final String validPassword = _password.value;

    try {
      await AuthService().createAccount(
        email: validEmail,
        password: validPassword,
        firstname: validFirstname,
        lastname: validLastname,
        middlename: validMiddlename,
      );
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _firstname.close();
    _middlename.close();
    _lastname.close();

    _email.close();
    _password.close();
    _isLoading.close();
    _passwordVisibility.close();
  }
}
