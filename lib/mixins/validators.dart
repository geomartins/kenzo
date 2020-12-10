import 'dart:async';

class Validators {
  //<String, String> input output
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);
      } else {
        sink.addError('Enter valid email address');
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 3) {
        sink.add(password);
      } else {
        sink.addError('Invalid password');
      }
    },
  );

  final validateFirstname = StreamTransformer<String, String>.fromHandlers(
    handleData: (firstname, sink) {
      if (firstname.length > 3) {
        sink.add(firstname);
      } else {
        sink.addError('Invalid firstname');
      }
    },
  );

  final validateMiddlename = StreamTransformer<String, String>.fromHandlers(
    handleData: (middlename, sink) {
      if (middlename.length > 3) {
        sink.add(middlename);
      } else {
        sink.addError('Invalid middlename');
      }
    },
  );

  final validateLastname = StreamTransformer<String, String>.fromHandlers(
    handleData: (lastname, sink) {
      if (lastname.length > 3) {
        sink.add(lastname);
      } else {
        sink.addError('Invalid lastname');
      }
    },
  );

  final lowerCaseX = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      sink.add(value.toLowerCase());
    },
  );
}
