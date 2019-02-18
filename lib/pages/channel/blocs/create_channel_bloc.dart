import 'dart:async';

import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:meta/meta.dart' show required;
import 'package:rxdart/rxdart.dart';

class CreateChannelBlocValidator {
  final Translation translation;

  CreateChannelBlocValidator(this.translation) : assert(translation != null);

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

class CreateChannelBloc extends BlocBase {
  static const String TAG = "AUTH_BLOC";

  final CreateChannelBlocValidator validator;

  CreateChannelBloc({@required this.validator}) : assert(validator != null);

  final _categoryNameSubject = BehaviorSubject<String>();
  final _typeSubject = BehaviorSubject<String>();
  final _titleSubject = BehaviorSubject<String>();
  final _descriptionSubject = BehaviorSubject<String>();
  final _priceSubject = BehaviorSubject<int>();
  final _targetFundSubject = BehaviorSubject<int>();

  Stream<String> get categoryName => _categoryNameSubject.stream.transform(validator.validateEmpty);
  Stream<String> get type => _typeSubject.stream.transform(validator.validateEmpty);
  Stream<String> get title => _titleSubject.stream.transform(validator.validateEmpty);
  Stream<String> get description => _descriptionSubject.stream.transform(validator.validateEmpty);
  Stream<String> get price => _priceSubject.stream.transform(validator.validateEmptyInt);
  Stream<String> get targetFund => _targetFundSubject.stream.transform(validator.validateEmptyInt);



  Stream<bool> get submitValid =>
      Observable.combineLatest6(
          categoryName, type, title, description, price, targetFund,
              (c, type, title, d, p, t) =>
                  !c.isEmpty && !type.isEmpty && !title.isEmpty && !d.isEmpty && (price != null) && (targetFund != null) );

  Function(String) get updateCategoryName => _categoryNameSubject.sink.add;
  Function(String) get updateType => _typeSubject.sink.add;
  Function(String) get updateTitle => _titleSubject.sink.add;
  Function(String) get updateDescription => _descriptionSubject.sink.add;
  Function(int) get updatePrice => _priceSubject.sink.add;
  Function(int) get updateTargetFund => _targetFundSubject.sink.add;

  dispose() {
    _categoryNameSubject.close();
    _typeSubject.close();
    _titleSubject.close();
    _descriptionSubject.close();
    _priceSubject.close();
    _targetFundSubject.close();
  }
}
