import 'dart:async';

import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:meta/meta.dart' show required;
import 'package:rxdart/rxdart.dart';

class AuthBlocValidator {
  final Translation translation;

  AuthBlocValidator(this.translation) : assert(translation != null);

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

  String Function(String t, String s) get zipPasswords =>
      (password, verify) => "$password\_$verify";

  StreamTransformer<String, String> get validatePasswordVerify =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (passwords, sink) {
          final values = passwords.split("_");
          if (values.length == 2) {
            final password = values[0];
            final verify = values[1];
            if (password != verify) {
              sink.addError(translation.errorPasswordMatch);
            } else {
              sink.add(verify);
            }
          }
        },
      );
}

class AuthBloc extends BlocBase {
  static const String TAG = "AUTH_BLOC";

  final AuthBlocValidator validator;

  AuthBloc({@required this.validator}) : assert(validator != null);

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _passwordVerifySubject = BehaviorSubject<String>();

  Stream<String> get email =>
      _emailSubject.stream.transform(validator.validateEmail);

  Stream<String> get password =>
      _passwordSubject.stream.transform(validator.validatePassword);

  Stream<String> get passwordVerify => _passwordVerifySubject.stream;

  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  Function(String) get updateEmail => _emailSubject.sink.add;
  Function(String) get updatePassword => _passwordSubject.sink.add;
  Function(String) get updatePasswordVerify => _passwordVerifySubject.sink.add;
  Function(String) get errorPasswordVerify =>
      _passwordVerifySubject.sink.addError;

  dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    _passwordVerifySubject.close();
  }
}
