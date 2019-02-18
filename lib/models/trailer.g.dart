// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trailer.dart';

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

Serializer<Trailer> _$trailerSerializer = new _$TrailerSerializer();

class _$TrailerSerializer implements StructuredSerializer<Trailer> {
  @override
  final Iterable<Type> types = const [Trailer, _$Trailer];
  @override
  final String wireName = 'Trailer';

  @override
  Iterable serialize(Serializers serializers, Trailer object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'trailerId',
      serializers.serialize(object.trailerId,
          specifiedType: const FullType(String)),
      'channelId',
      serializers.serialize(object.channelId,
          specifiedType: const FullType(String)),
      'channelName',
      serializers.serialize(object.channelName,
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
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'videoUrl',
      serializers.serialize(object.videoUrl,
          specifiedType: const FullType(String)),
      'createdDate',
      serializers.serialize(object.createdDate,
          specifiedType: const FullType(Timestamp)),
    ];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    if (object.channelImage != null) {
      result
        ..add('channelImage')
        ..add(serializers.serialize(object.channelImage,
            specifiedType: const FullType(String)));
    }
    if (object.video360 != null) {
      result
        ..add('video360')
        ..add(serializers.serialize(object.video360,
            specifiedType: const FullType(String)));
    }
    if (object.video720 != null) {
      result
        ..add('video720')
        ..add(serializers.serialize(object.video720,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Trailer deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TrailerBuilder();

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
        case 'trailerId':
          result.trailerId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelId':
          result.channelId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelName':
          result.channelName = serializers.deserialize(value,
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
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'videoUrl':
          result.videoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelImage':
          result.channelImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'video360':
          result.video360 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'video720':
          result.video720 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdDate':
          result.createdDate = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp)) as Timestamp;
          break;
      }
    }

    return result.build();
  }
}

class _$Trailer extends Trailer {
  @override
  final String userId;
  @override
  final String trailerId;
  @override
  final String channelId;
  @override
  final String channelName;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String createdBy;
  @override
  final String title;
  @override
  final String description;
  @override
  final String videoUrl;
  @override
  final String image;
  @override
  final String channelImage;
  @override
  final String video360;
  @override
  final String video720;
  @override
  final Timestamp createdDate;

  factory _$Trailer([void updates(TrailerBuilder b)]) =>
      (new TrailerBuilder()..update(updates)).build();

  _$Trailer._(
      {this.userId,
      this.trailerId,
      this.channelId,
      this.channelName,
      this.categoryId,
      this.categoryName,
      this.createdBy,
      this.title,
      this.description,
      this.videoUrl,
      this.image,
      this.channelImage,
      this.video360,
      this.video720,
      this.createdDate})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Trailer', 'userId');
    }
    if (trailerId == null) {
      throw new BuiltValueNullFieldError('Trailer', 'trailerId');
    }
    if (channelId == null) {
      throw new BuiltValueNullFieldError('Trailer', 'channelId');
    }
    if (channelName == null) {
      throw new BuiltValueNullFieldError('Trailer', 'channelName');
    }
    if (categoryId == null) {
      throw new BuiltValueNullFieldError('Trailer', 'categoryId');
    }
    if (categoryName == null) {
      throw new BuiltValueNullFieldError('Trailer', 'categoryName');
    }
    if (createdBy == null) {
      throw new BuiltValueNullFieldError('Trailer', 'createdBy');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Trailer', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Trailer', 'description');
    }
    if (videoUrl == null) {
      throw new BuiltValueNullFieldError('Trailer', 'videoUrl');
    }
    if (createdDate == null) {
      throw new BuiltValueNullFieldError('Trailer', 'createdDate');
    }
  }

  @override
  Trailer rebuild(void updates(TrailerBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TrailerBuilder toBuilder() => new TrailerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Trailer &&
        userId == other.userId &&
        trailerId == other.trailerId &&
        channelId == other.channelId &&
        channelName == other.channelName &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        createdBy == other.createdBy &&
        title == other.title &&
        description == other.description &&
        videoUrl == other.videoUrl &&
        image == other.image &&
        channelImage == other.channelImage &&
        video360 == other.video360 &&
        video720 == other.video720 &&
        createdDate == other.createdDate;
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
                                                                0,
                                                                userId
                                                                    .hashCode),
                                                            trailerId.hashCode),
                                                        channelId.hashCode),
                                                    channelName.hashCode),
                                                categoryId.hashCode),
                                            categoryName.hashCode),
                                        createdBy.hashCode),
                                    title.hashCode),
                                description.hashCode),
                            videoUrl.hashCode),
                        image.hashCode),
                    channelImage.hashCode),
                video360.hashCode),
            video720.hashCode),
        createdDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Trailer')
          ..add('userId', userId)
          ..add('trailerId', trailerId)
          ..add('channelId', channelId)
          ..add('channelName', channelName)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('createdBy', createdBy)
          ..add('title', title)
          ..add('description', description)
          ..add('videoUrl', videoUrl)
          ..add('image', image)
          ..add('channelImage', channelImage)
          ..add('video360', video360)
          ..add('video720', video720)
          ..add('createdDate', createdDate))
        .toString();
  }
}

class TrailerBuilder implements Builder<Trailer, TrailerBuilder> {
  _$Trailer _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _trailerId;
  String get trailerId => _$this._trailerId;
  set trailerId(String trailerId) => _$this._trailerId = trailerId;

  String _channelId;
  String get channelId => _$this._channelId;
  set channelId(String channelId) => _$this._channelId = channelId;

  String _channelName;
  String get channelName => _$this._channelName;
  set channelName(String channelName) => _$this._channelName = channelName;

  String _categoryId;
  String get categoryId => _$this._categoryId;
  set categoryId(String categoryId) => _$this._categoryId = categoryId;

  String _categoryName;
  String get categoryName => _$this._categoryName;
  set categoryName(String categoryName) => _$this._categoryName = categoryName;

  String _createdBy;
  String get createdBy => _$this._createdBy;
  set createdBy(String createdBy) => _$this._createdBy = createdBy;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _videoUrl;
  String get videoUrl => _$this._videoUrl;
  set videoUrl(String videoUrl) => _$this._videoUrl = videoUrl;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _channelImage;
  String get channelImage => _$this._channelImage;
  set channelImage(String channelImage) => _$this._channelImage = channelImage;

  String _video360;
  String get video360 => _$this._video360;
  set video360(String video360) => _$this._video360 = video360;

  String _video720;
  String get video720 => _$this._video720;
  set video720(String video720) => _$this._video720 = video720;

  Timestamp _createdDate;
  Timestamp get createdDate => _$this._createdDate;
  set createdDate(Timestamp createdDate) => _$this._createdDate = createdDate;

  TrailerBuilder();

  TrailerBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _trailerId = _$v.trailerId;
      _channelId = _$v.channelId;
      _channelName = _$v.channelName;
      _categoryId = _$v.categoryId;
      _categoryName = _$v.categoryName;
      _createdBy = _$v.createdBy;
      _title = _$v.title;
      _description = _$v.description;
      _videoUrl = _$v.videoUrl;
      _image = _$v.image;
      _channelImage = _$v.channelImage;
      _video360 = _$v.video360;
      _video720 = _$v.video720;
      _createdDate = _$v.createdDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Trailer other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Trailer;
  }

  @override
  void update(void updates(TrailerBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Trailer build() {
    final _$result = _$v ??
        new _$Trailer._(
            userId: userId,
            trailerId: trailerId,
            channelId: channelId,
            channelName: channelName,
            categoryId: categoryId,
            categoryName: categoryName,
            createdBy: createdBy,
            title: title,
            description: description,
            videoUrl: videoUrl,
            image: image,
            channelImage: channelImage,
            video360: video360,
            video720: video720,
            createdDate: createdDate);
    replace(_$result);
    return _$result;
  }
}
