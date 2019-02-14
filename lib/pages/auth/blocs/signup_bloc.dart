import 'dart:async';
import 'dart:io';

import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/models/user.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBlocValidator {
  final Translation translation;

  SignUpBlocValidator(this.translation) : assert(translation != null);

  StreamTransformer<String, String> get validateField =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (text, sink) {
          if (text.isEmpty) {
            sink.addError(translation.errorEmptyField);
          } else {
            sink.add(text);
          }
        },
      );

  StreamTransformer<String, String> get validateEmail =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (email, sink) {
          String validationRule =
              r"\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b";
          if (RegExp(validationRule).hasMatch(email)) {
            sink.add(email);
          } else if (email.isEmpty) {
            sink.addError(translation.errorEmptyField);
          } else {
            sink.addError(translation.errorEmailFormat);
          }
        },
      );

  StreamTransformer<String, String> get validatePassword =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (password, sink) {
          if (password.length >= 8) {
            sink.add(password);
          } else if (password.isEmpty) {
            sink.addError(translation.errorEmptyField);
          } else {
            sink.addError(translation.errorPasswordFormat);
          }
        },
      );

}

class SignUpBloc extends BlocBase {
  static const String TAG = "SIGN_UP_BLOC";

  final Translation translation;
  SignUpBlocValidator validator;

  SignUpBloc(this.translation) {
    this.validator = SignUpBlocValidator(translation);
  }

  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  Stream<String> get firstName =>
      _firstNameSubject.stream.transform(validator.validateField);

  Stream<String> get lastName =>
      _lastNameSubject.stream.transform(validator.validateField);

  Stream<String> get email =>
      _emailSubject.stream.transform(validator.validateEmail);

  Stream<String> get password =>
      _passwordSubject.stream.transform(validator.validatePassword);


  Stream<bool> get submitValid => Observable.combineLatest4(
    firstName,
    lastName,
    email,
    password,
        (String f, String l, String e, String p) {
      return f != null && l != null && e != null && p != null;
        });

  Function(String) get updateFirstName => _firstNameSubject.sink.add;
  Function(String) get updateLastName => _lastNameSubject.sink.add;
  Function(String) get updateEmail => _emailSubject.sink.add;
  Function(String) get updatePassword => _passwordSubject.sink.add;

  dispose() {
    _firstNameSubject?.close();
    _lastNameSubject?.close();
    _emailSubject?.close();
    _passwordSubject?.close();
  }
}
