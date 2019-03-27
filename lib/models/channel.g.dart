// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

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

Serializer<Channel> _$channelSerializer = new _$ChannelSerializer();

class _$ChannelSerializer implements StructuredSerializer<Channel> {
  @override
  final Iterable<Type> types = const [Channel, _$Channel];
  @override
  final String wireName = 'Channel';

  @override
  Iterable serialize(Serializers serializers, Channel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'channelId',
      serializers.serialize(object.channelId,
          specifiedType: const FullType(String)),
      'categoryId',
      serializers.serialize(object.categoryId,
          specifiedType: const FullType(String)),
      'categoryName',
      serializers.serialize(object.categoryName,
          specifiedType: const FullType(String)),
      'createdBy',
      serializers.serialize(object.createdBy,
          specifiedType: const FullType(String)),
      'channelType',
      serializers.serialize(object.channelType,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'createdDate',
      serializers.serialize(object.createdDate,
          specifiedType: const FullType(Timestamp)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
    ];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    if (object.coverImage != null) {
      result
        ..add('coverImage')
        ..add(serializers.serialize(object.coverImage,
            specifiedType: const FullType(String)));
    }
    if (object.subscriberCount != null) {
      result
        ..add('subscriberCount')
        ..add(serializers.serialize(object.subscriberCount,
            specifiedType: const FullType(int)));
    }
    if (object.targetFund != null) {
      result
        ..add('targetFund')
        ..add(serializers.serialize(object.targetFund,
            specifiedType: const FullType(double)));
    }
    if (object.currentFund != null) {
      result
        ..add('currentFund')
        ..add(serializers.serialize(object.currentFund,
            specifiedType: const FullType(double)));
    }
    if (object.percentage != null) {
      result
        ..add('percentage')
        ..add(serializers.serialize(object.percentage,
            specifiedType: const FullType(double)));
    }

    return result;
  }

  @override
  Channel deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChannelBuilder();

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
        case 'categoryId':
          result.categoryId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'categoryName':
          result.categoryName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdBy':
          result.createdBy = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelType':
          result.channelType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'coverImage':
          result.coverImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdDate':
          result.createdDate = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp)) as Timestamp;
          break;
        case 'subscriberCount':
          result.subscriberCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'targetFund':
          result.targetFund = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'currentFund':
          result.currentFund = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'percentage':
          result.percentage = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$Channel extends Channel {
  @override
  final String userId;
  @override
  final String channelId;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String createdBy;
  @override
  final String channelType;
  @override
  final String title;
  @override
  final String description;
  @override
  final String image;
  @override
  final String coverImage;
  @override
  final Timestamp createdDate;
  @override
  final int subscriberCount;
  @override
  final double price;
  @override
  final double targetFund;
  @override
  final double currentFund;
  @override
  final double percentage;

  factory _$Channel([void updates(ChannelBuilder b)]) =>
      (new ChannelBuilder()..update(updates)).build();

  _$Channel._(
      {this.userId,
      this.channelId,
      this.categoryId,
      this.categoryName,
      this.createdBy,
      this.channelType,
      this.title,
      this.description,
      this.image,
      this.coverImage,
      this.createdDate,
      this.subscriberCount,
      this.price,
      this.targetFund,
      this.currentFund,
      this.percentage})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Channel', 'userId');
    }
    if (channelId == null) {
      throw new BuiltValueNullFieldError('Channel', 'channelId');
    }
    if (categoryId == null) {
      throw new BuiltValueNullFieldError('Channel', 'categoryId');
    }
    if (categoryName == null) {
      throw new BuiltValueNullFieldError('Channel', 'categoryName');
    }
    if (createdBy == null) {
      throw new BuiltValueNullFieldError('Channel', 'createdBy');
    }
    if (channelType == null) {
      throw new BuiltValueNullFieldError('Channel', 'channelType');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Channel', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Channel', 'description');
    }
    if (createdDate == null) {
      throw new BuiltValueNullFieldError('Channel', 'createdDate');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('Channel', 'price');
    }
  }

  @override
  Channel rebuild(void updates(ChannelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelBuilder toBuilder() => new ChannelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Channel &&
        userId == other.userId &&
        channelId == other.channelId &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        createdBy == other.createdBy &&
        channelType == other.channelType &&
        title == other.title &&
        description == other.description &&
        image == other.image &&
        coverImage == other.coverImage &&
        createdDate == other.createdDate &&
        subscriberCount == other.subscriberCount &&
        price == other.price &&
        targetFund == other.targetFund &&
        currentFund == other.currentFund &&
        percentage == other.percentage;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    0,
                                                                    userId
                                                                        .hashCode),
                                                                channelId
                                                                    .hashCode),
                                                            categoryId
                                                                .hashCode),
                                                        categoryName.hashCode),
                                                    createdBy.hashCode),
                                                channelType.hashCode),
                                            title.hashCode),
                                        description.hashCode),
                                    image.hashCode),
                                coverImage.hashCode),
                            createdDate.hashCode),
                        subscriberCount.hashCode),
                    price.hashCode),
                targetFund.hashCode),
            currentFund.hashCode),
        percentage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Channel')
          ..add('userId', userId)
          ..add('channelId', channelId)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('createdBy', createdBy)
          ..add('channelType', channelType)
          ..add('title', title)
          ..add('description', description)
          ..add('image', image)
          ..add('coverImage', coverImage)
          ..add('createdDate', createdDate)
          ..add('subscriberCount', subscriberCount)
          ..add('price', price)
          ..add('targetFund', targetFund)
          ..add('currentFund', currentFund)
          ..add('percentage', percentage))
        .toString();
  }
}

class ChannelBuilder implements Builder<Channel, ChannelBuilder> {
  _$Channel _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _channelId;
  String get channelId => _$this._channelId;
  set channelId(String channelId) => _$this._channelId = channelId;

  String _categoryId;
  String get categoryId => _$this._categoryId;
  set categoryId(String categoryId) => _$this._categoryId = categoryId;

  String _categoryName;
  String get categoryName => _$this._categoryName;
  set categoryName(String categoryName) => _$this._categoryName = categoryName;

  String _createdBy;
  String get createdBy => _$this._createdBy;
  set createdBy(String createdBy) => _$this._createdBy = createdBy;

  String _channelType;
  String get channelType => _$this._channelType;
  set channelType(String channelType) => _$this._channelType = channelType;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _coverImage;
  String get coverImage => _$this._coverImage;
  set coverImage(String coverImage) => _$this._coverImage = coverImage;

  Timestamp _createdDate;
  Timestamp get createdDate => _$this._createdDate;
  set createdDate(Timestamp createdDate) => _$this._createdDate = createdDate;

  int _subscriberCount;
  int get subscriberCount => _$this._subscriberCount;
  set subscriberCount(int subscriberCount) =>
      _$this._subscriberCount = subscriberCount;

  double _price;
  double get price => _$this._price;
  set price(double price) => _$this._price = price;

  double _targetFund;
  double get targetFund => _$this._targetFund;
  set targetFund(double targetFund) => _$this._targetFund = targetFund;

  double _currentFund;
  double get currentFund => _$this._currentFund;
  set currentFund(double currentFund) => _$this._currentFund = currentFund;

  double _percentage;
  double get percentage => _$this._percentage;
  set percentage(double percentage) => _$this._percentage = percentage;

  ChannelBuilder();

  ChannelBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _channelId = _$v.channelId;
      _categoryId = _$v.categoryId;
      _categoryName = _$v.categoryName;
      _createdBy = _$v.createdBy;
      _channelType = _$v.channelType;
      _title = _$v.title;
      _description = _$v.description;
      _image = _$v.image;
      _coverImage = _$v.coverImage;
      _createdDate = _$v.createdDate;
      _subscriberCount = _$v.subscriberCount;
      _price = _$v.price;
      _targetFund = _$v.targetFund;
      _currentFund = _$v.currentFund;
      _percentage = _$v.percentage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Channel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Channel;
  }

  @override
  void update(void updates(ChannelBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Channel build() {
    final _$result = _$v ??
        new _$Channel._(
            userId: userId,
            channelId: channelId,
            categoryId: categoryId,
            categoryName: categoryName,
            createdBy: createdBy,
            channelType: channelType,
            title: title,
            description: description,
            image: image,
            coverImage: coverImage,
            createdDate: createdDate,
            subscriberCount: subscriberCount,
            price: price,
            targetFund: targetFund,
            currentFund: currentFund,
            percentage: percentage);
    replace(_$result);
    return _$result;
  }
}
