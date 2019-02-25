import 'dart:async';

import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:meta/meta.dart' show required;
import 'package:rxdart/rxdart.dart';

class AddTrailerBlocValidator {
  final Translation translation;

  AddTrailerBlocValidator(this.translation) : assert(translation != null);

  StreamTransformer<String, String> get validateEmpty => 
      StreamTransformer<String, String>.fromHandlers(
        handleData: (data, sink) {
          if(data.isEmpty) {
            sink.addError(translation.cannotBeEmpty);
          } else {
            sink.add(data);
          }
        }
      );

  StreamTransformer<int, String> get validateEmptyInt =>
      StreamTransformer<int, String>.fromHandlers(
        handleData: (data, sink) {
          if(data == null) {
            sink.addError(translation.cannotBeEmpty);
          } else {
            sink.add(data.toString());
          }
        }
      );
}

class AddTrailerBloc extends BlocBase {
  static const String TAG = "ADD_TRAILER_BLOC";

  final AddTrailerBlocValidator validator;

  AddTrailerBloc({@required this.validator}) : assert(validator != null);

  final _titleSubject = BehaviorSubject<String>();
  final _descriptionSubject = BehaviorSubject<String>();

  Stream<String> get title => _titleSubject.stream.transform(validator.validateEmpty);
  Stream<String> get description => _descriptionSubject.stream.transform(validator.validateEmpty);


  Stream<bool> get submitValid =>
      Observable.combineLatest2(
          title, description,
              (title, d) =>
                  !title.isEmpty && !d.isEmpty);

  Function(String) get updateTitle => _titleSubject.sink.add;
  Function(String) get updateDescription => _descriptionSubject.sink.add;

  dispose() {
    _titleSubject.close();
    _descriptionSubject.close();
  }
}
