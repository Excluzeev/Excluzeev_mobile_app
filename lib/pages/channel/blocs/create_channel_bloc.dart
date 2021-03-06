import 'dart:async';

import 'package:trenstop/i18n/translation.dart';
import 'package:trenstop/pages/bloc_provider.dart';
import 'package:meta/meta.dart' show required;
import 'package:rxdart/rxdart.dart';

class CreateChannelBlocValidator {
  final Translation translation;

  CreateChannelBlocValidator(this.translation) : assert(translation != null);

  StreamTransformer<String, String> get validateEmpty =>
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
        if (data.isEmpty) {
          sink.addError(translation.cannotBeEmpty);
        } else {
          sink.add(data);
        }
      });

  StreamTransformer<String, String> get validateChannelType =>
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
        if (data.isEmpty) {
          sink.addError(translation.cannotBeEmpty);
        } else {
          sink.add(data);
        }
      });

  StreamTransformer<int, String> get validateEmptyInt =>
      StreamTransformer<int, String>.fromHandlers(handleData: (data, sink) {
        if (data == null) {
          sink.addError(translation.cannotBeEmpty);
        } else {
          sink.add(data.toString());
        }
      });
  StreamTransformer<double, String> get validateTargetFund =>
      StreamTransformer<double, String>.fromHandlers(handleData: (data, sink) {
        if (data == null) {
          sink.add("0");
        } else {
          sink.add(data.toString());
        }
      });

  StreamTransformer<double, String> get validatePriceInt =>
      StreamTransformer<double, String>.fromHandlers(handleData: (data, sink) {
        if (data == null) {
          sink.addError(translation.cannotBeEmpty);
        } else if (data < 2.0) {
          sink.addError(translation.priceError);
        } else {
          sink.add(data.toString());
        }
      });
}

class CreateChannelBloc extends BlocBase {
  static const String TAG = "AUTH_BLOC";

  final CreateChannelBlocValidator validator;

  CreateChannelBloc({@required this.validator}) : assert(validator != null) {
    _priceSubject.add(1.0);
  }

  final _categoryNameSubject = BehaviorSubject<String>();
  final _typeSubject = BehaviorSubject<String>();
  final _titleSubject = BehaviorSubject<String>();
  final _descriptionSubject = BehaviorSubject<String>();
  final _priceSubject = BehaviorSubject<double>();
  final _targetFundSubject = BehaviorSubject<double>();

  Stream<String> get categoryName =>
      _categoryNameSubject.stream.transform(validator.validateEmpty);
  Stream<String> get type =>
      _typeSubject.stream.transform(validator.validateEmpty);
  Stream<String> get title =>
      _titleSubject.stream.transform(validator.validateEmpty);
  Stream<String> get description =>
      _descriptionSubject.stream.transform(validator.validateEmpty);
  Stream<String> get price =>
      _priceSubject.stream.transform(validator.validatePriceInt);
  Stream<String> get targetFund =>
      _targetFundSubject.stream.transform(validator.validateTargetFund);

  Stream<bool> get submitValid => Observable.combineLatest3(categoryName, title,
      description, (c, title, d) => !c.isEmpty && !title.isEmpty && !d.isEmpty);

  Function(String) get updateCategoryName => _categoryNameSubject.sink.add;
  Function(String) get updateType => _typeSubject.sink.add;
  Function(String) get updateTitle => _titleSubject.sink.add;
  Function(String) get updateDescription => _descriptionSubject.sink.add;
  Function(double) get updatePrice => _priceSubject.sink.add;
  Function(double) get updateTargetFund => _targetFundSubject.sink.add;

  dispose() {
    _categoryNameSubject.close();
    _typeSubject.close();
    _titleSubject.close();
    _descriptionSubject.close();
    _priceSubject.close();
    _targetFundSubject.close();
  }
}
