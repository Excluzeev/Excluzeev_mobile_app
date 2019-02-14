
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/bloc_provider.dart';

class ForgotPasswordValidator {
  final Translation translation;

  ForgotPasswordValidator(this.translation): assert(translation != null);

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
}

class ForgotPasswordBloc extends BlocBase {

  final Translation translation;
  ForgotPasswordValidator validator;

  ForgotPasswordBloc(this.translation) {
    this.validator = ForgotPasswordValidator(translation);
  }

  final _emailSubject = BehaviorSubject<String>();

  Stream<String> get email =>
      _emailSubject.stream.transform(validator.validateEmail);

//  Stream<bool> get emailValid => _emailSubject.stream.


  Function(String) get updateEmail => _emailSubject.sink.add;

  @override
  void dispose() {
    _emailSubject?.close();
  }

}