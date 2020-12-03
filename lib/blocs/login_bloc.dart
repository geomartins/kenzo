import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:staff_portal/mixins/validators.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:staff_portal/services/auth_service.dart';

class LoginBloc extends Object with Validators {
  BehaviorSubject _email = new BehaviorSubject<String>();
  BehaviorSubject _password = new BehaviorSubject<String>();
  BehaviorSubject _isLoading = new BehaviorSubject<bool>();

  void emailSink(String value) {
    _email.sink.add(value);
  }

  void passwordSink(String value) {
    _password.sink.add(value);
  }

  void loadingSink(bool value) {
    _isLoading.sink.add(value);
  }

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream get isLoading => _isLoading.stream;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (e, p) => true);

  Future<UserModel> submit() async {
    final String validEmail = _email.value;
    final String validPassword = _password.value;

    try {
      UserModel user = await AuthService()
          .loginWithEmailAndPassword(validEmail, validPassword);
      if (user != null) {
        print(user.email);
        print(user.uid);
        return user;
      }
    } catch (e) {
      rethrow;
    }
  }

//
//  //Change Data
//  Function(String) get changeEmail => _email.sink.add;
//  Function(String) get changePassword => _password.sink.add;
//

  void dispose() {
    _email.close();
    _password.close();
    _isLoading.close();
  }
}
