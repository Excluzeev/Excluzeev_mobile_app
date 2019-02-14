// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

Serializer<User> _$userSerializer = new _$UserSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
    ];
    if (object.firstName != null) {
      result
        ..add('firstName')
        ..add(serializers.serialize(object.firstName,
            specifiedType: const FullType(String)));
    }
    if (object.lastName != null) {
      result
        ..add('lastName')
        ..add(serializers.serialize(object.lastName,
            specifiedType: const FullType(String)));
    }
    if (object.userPhoto != null) {
      result
        ..add('userPhoto')
        ..add(serializers.serialize(object.userPhoto,
            specifiedType: const FullType(String)));
    }
    if (object.isContentCreator != null) {
      result
        ..add('isContentCreator')
        ..add(serializers.serialize(object.isContentCreator,
            specifiedType: const FullType(bool)));
    }
    if (object.paypalEmail != null) {
      result
        ..add('paypalEmail')
        ..add(serializers.serialize(object.paypalEmail,
            specifiedType: const FullType(String)));
    }
    if (object.subscribedChannels != null) {
      result
        ..add('subscribedChannels')
        ..add(serializers.serialize(object.subscribedChannels,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }

    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'firstName':
          result.firstName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'lastName':
          result.lastName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userPhoto':
          result.userPhoto = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isContentCreator':
          result.isContentCreator = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'paypalEmail':
          result.paypalEmail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subscribedChannels':
          result.subscribedChannels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$User extends User {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String userPhoto;
  @override
  final bool isContentCreator;
  @override
  final String paypalEmail;
  @override
  final BuiltList<String> subscribedChannels;

  factory _$User([void updates(UserBuilder b)]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.userPhoto,
      this.isContentCreator,
      this.paypalEmail,
      this.subscribedChannels})
      : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('User', 'uid');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('User', 'email');
    }
  }

  @override
  User rebuild(void updates(UserBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        uid == other.uid &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        userPhoto == other.userPhoto &&
        isContentCreator == other.isContentCreator &&
        paypalEmail == other.paypalEmail &&
        subscribedChannels == other.subscribedChannels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, uid.hashCode), email.hashCode),
                            firstName.hashCode),
                        lastName.hashCode),
                    userPhoto.hashCode),
                isContentCreator.hashCode),
            paypalEmail.hashCode),
        subscribedChannels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('uid', uid)
          ..add('email', email)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('userPhoto', userPhoto)
          ..add('isContentCreator', isContentCreator)
          ..add('paypalEmail', paypalEmail)
          ..add('subscribedChannels', subscribedChannels))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _firstName;
  String get firstName => _$this._firstName;
  set firstName(String firstName) => _$this._firstName = firstName;

  String _lastName;
  String get lastName => _$this._lastName;
  set lastName(String lastName) => _$this._lastName = lastName;

  String _userPhoto;
  String get userPhoto => _$this._userPhoto;
  set userPhoto(String userPhoto) => _$this._userPhoto = userPhoto;

  bool _isContentCreator;
  bool get isContentCreator => _$this._isContentCreator;
  set isContentCreator(bool isContentCreator) =>
      _$this._isContentCreator = isContentCreator;

  String _paypalEmail;
  String get paypalEmail => _$this._paypalEmail;
  set paypalEmail(String paypalEmail) => _$this._paypalEmail = paypalEmail;

  ListBuilder<String> _subscribedChannels;
  ListBuilder<String> get subscribedChannels =>
      _$this._subscribedChannels ??= new ListBuilder<String>();
  set subscribedChannels(ListBuilder<String> subscribedChannels) =>
      _$this._subscribedChannels = subscribedChannels;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _email = _$v.email;
      _firstName = _$v.firstName;
      _lastName = _$v.lastName;
      _userPhoto = _$v.userPhoto;
      _isContentCreator = _$v.isContentCreator;
      _paypalEmail = _$v.paypalEmail;
      _subscribedChannels = _$v.subscribedChannels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void updates(UserBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ??
          new _$User._(
              uid: uid,
              email: email,
              firstName: firstName,
              lastName: lastName,
              userPhoto: userPhoto,
              isContentCreator: isContentCreator,
              paypalEmail: paypalEmail,
              subscribedChannels: _subscribedChannels?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'subscribedChannels';
        _subscribedChannels?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
