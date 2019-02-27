// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

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

Serializer<Subscription> _$subscriptionSerializer =
    new _$SubscriptionSerializer();

class _$SubscriptionSerializer implements StructuredSerializer<Subscription> {
  @override
  final Iterable<Type> types = const [Subscription, _$Subscription];
  @override
  final String wireName = 'Subscription';

  @override
  Iterable serialize(Serializers serializers, Subscription object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'channelId',
      serializers.serialize(object.channelId,
          specifiedType: const FullType(String)),
      'subscribedDate',
      serializers.serialize(object.subscribedDate,
          specifiedType: const FullType(String)),
      'channelName',
      serializers.serialize(object.channelName,
          specifiedType: const FullType(String)),
      'channelImage',
      serializers.serialize(object.channelImage,
          specifiedType: const FullType(String)),
      'expiryDate',
      serializers.serialize(object.expiryDate,
          specifiedType: const FullType(String)),
      'subscriptionId',
      serializers.serialize(object.subscriptionId,
          specifiedType: const FullType(String)),
      'isActive',
      serializers.serialize(object.isActive,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Subscription deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubscriptionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelId':
          result.channelId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subscribedDate':
          result.subscribedDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelName':
          result.channelName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelImage':
          result.channelImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'expiryDate':
          result.expiryDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'subscriptionId':
          result.subscriptionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isActive':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Subscription extends Subscription {
  @override
  final String userId;
  @override
  final String channelId;
  @override
  final String subscribedDate;
  @override
  final String channelName;
  @override
  final String channelImage;
  @override
  final String expiryDate;
  @override
  final String subscriptionId;
  @override
  final bool isActive;

  factory _$Subscription([void updates(SubscriptionBuilder b)]) =>
      (new SubscriptionBuilder()..update(updates)).build();

  _$Subscription._(
      {this.userId,
      this.channelId,
      this.subscribedDate,
      this.channelName,
      this.channelImage,
      this.expiryDate,
      this.subscriptionId,
      this.isActive})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Subscription', 'userId');
    }
    if (channelId == null) {
      throw new BuiltValueNullFieldError('Subscription', 'channelId');
    }
    if (subscribedDate == null) {
      throw new BuiltValueNullFieldError('Subscription', 'subscribedDate');
    }
    if (channelName == null) {
      throw new BuiltValueNullFieldError('Subscription', 'channelName');
    }
    if (channelImage == null) {
      throw new BuiltValueNullFieldError('Subscription', 'channelImage');
    }
    if (expiryDate == null) {
      throw new BuiltValueNullFieldError('Subscription', 'expiryDate');
    }
    if (subscriptionId == null) {
      throw new BuiltValueNullFieldError('Subscription', 'subscriptionId');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('Subscription', 'isActive');
    }
  }

  @override
  Subscription rebuild(void updates(SubscriptionBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionBuilder toBuilder() => new SubscriptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Subscription &&
        userId == other.userId &&
        channelId == other.channelId &&
        subscribedDate == other.subscribedDate &&
        channelName == other.channelName &&
        channelImage == other.channelImage &&
        expiryDate == other.expiryDate &&
        subscriptionId == other.subscriptionId &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, userId.hashCode), channelId.hashCode),
                            subscribedDate.hashCode),
                        channelName.hashCode),
                    channelImage.hashCode),
                expiryDate.hashCode),
            subscriptionId.hashCode),
        isActive.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Subscription')
          ..add('userId', userId)
          ..add('channelId', channelId)
          ..add('subscribedDate', subscribedDate)
          ..add('channelName', channelName)
          ..add('channelImage', channelImage)
          ..add('expiryDate', expiryDate)
          ..add('subscriptionId', subscriptionId)
          ..add('isActive', isActive))
        .toString();
  }
}

class SubscriptionBuilder
    implements Builder<Subscription, SubscriptionBuilder> {
  _$Subscription _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _channelId;
  String get channelId => _$this._channelId;
  set channelId(String channelId) => _$this._channelId = channelId;

  String _subscribedDate;
  String get subscribedDate => _$this._subscribedDate;
  set subscribedDate(String subscribedDate) =>
      _$this._subscribedDate = subscribedDate;

  String _channelName;
  String get channelName => _$this._channelName;
  set channelName(String channelName) => _$this._channelName = channelName;

  String _channelImage;
  String get channelImage => _$this._channelImage;
  set channelImage(String channelImage) => _$this._channelImage = channelImage;

  String _expiryDate;
  String get expiryDate => _$this._expiryDate;
  set expiryDate(String expiryDate) => _$this._expiryDate = expiryDate;

  String _subscriptionId;
  String get subscriptionId => _$this._subscriptionId;
  set subscriptionId(String subscriptionId) =>
      _$this._subscriptionId = subscriptionId;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  SubscriptionBuilder();

  SubscriptionBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _channelId = _$v.channelId;
      _subscribedDate = _$v.subscribedDate;
      _channelName = _$v.channelName;
      _channelImage = _$v.channelImage;
      _expiryDate = _$v.expiryDate;
      _subscriptionId = _$v.subscriptionId;
      _isActive = _$v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Subscription other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Subscription;
  }

  @override
  void update(void updates(SubscriptionBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Subscription build() {
    final _$result = _$v ??
        new _$Subscription._(
            userId: userId,
            channelId: channelId,
            subscribedDate: subscribedDate,
            channelName: channelName,
            channelImage: channelImage,
            expiryDate: expiryDate,
            subscriptionId: subscriptionId,
            isActive: isActive);
    replace(_$result);
    return _$result;
  }
}
