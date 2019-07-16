// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trailer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
      'channelType',
      serializers.serialize(object.channelType,
          specifiedType: const FullType(String)),
      'createdDate',
      serializers.serialize(object.createdDate,
          specifiedType: const FullType(Timestamp)),
    ];
    if (object.likes != null) {
      result
        ..add('likes')
        ..add(serializers.serialize(object.likes,
            specifiedType: const FullType(int)));
    }
    if (object.dislikes != null) {
      result
        ..add('dislikes')
        ..add(serializers.serialize(object.dislikes,
            specifiedType: const FullType(int)));
    }
    if (object.neutral != null) {
      result
        ..add('neutral')
        ..add(serializers.serialize(object.neutral,
            specifiedType: const FullType(int)));
    }
    if (object.views != null) {
      result
        ..add('views')
        ..add(serializers.serialize(object.views,
            specifiedType: const FullType(int)));
    }
    if (object.originalUrl != null) {
      result
        ..add('originalUrl')
        ..add(serializers.serialize(object.originalUrl,
            specifiedType: const FullType(String)));
    }
    if (object.playbackId != null) {
      result
        ..add('playbackId')
        ..add(serializers.serialize(object.playbackId,
            specifiedType: const FullType(String)));
    }
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
    if (object.expiry != null) {
      result
        ..add('expiry')
        ..add(serializers.serialize(object.expiry,
            specifiedType: const FullType(DateTime)));
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
        case 'channelType':
          result.channelType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'likes':
          result.likes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'dislikes':
          result.dislikes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'neutral':
          result.neutral = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'views':
          result.views = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'originalUrl':
          result.originalUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'playbackId':
          result.playbackId = serializers.deserialize(value,
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
        case 'createdDate':
          result.createdDate = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp)) as Timestamp;
          break;
        case 'expiry':
          result.expiry = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
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
  final String channelType;
  @override
  final int likes;
  @override
  final int dislikes;
  @override
  final int neutral;
  @override
  final int views;
  @override
  final String originalUrl;
  @override
  final String playbackId;
  @override
  final String image;
  @override
  final String channelImage;
  @override
  final Timestamp createdDate;
  @override
  final DateTime expiry;

  factory _$Trailer([void Function(TrailerBuilder) updates]) =>
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
      this.channelType,
      this.likes,
      this.dislikes,
      this.neutral,
      this.views,
      this.originalUrl,
      this.playbackId,
      this.image,
      this.channelImage,
      this.createdDate,
      this.expiry})
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
    if (channelType == null) {
      throw new BuiltValueNullFieldError('Trailer', 'channelType');
    }
    if (createdDate == null) {
      throw new BuiltValueNullFieldError('Trailer', 'createdDate');
    }
  }

  @override
  Trailer rebuild(void Function(TrailerBuilder) updates) =>
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
        channelType == other.channelType &&
        likes == other.likes &&
        dislikes == other.dislikes &&
        neutral == other.neutral &&
        views == other.views &&
        originalUrl == other.originalUrl &&
        playbackId == other.playbackId &&
        image == other.image &&
        channelImage == other.channelImage &&
        createdDate == other.createdDate &&
        expiry == other.expiry;
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
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc(0, userId.hashCode), trailerId.hashCode),
                                                                                channelId.hashCode),
                                                                            channelName.hashCode),
                                                                        categoryId.hashCode),
                                                                    categoryName.hashCode),
                                                                createdBy.hashCode),
                                                            title.hashCode),
                                                        description.hashCode),
                                                    videoUrl.hashCode),
                                                channelType.hashCode),
                                            likes.hashCode),
                                        dislikes.hashCode),
                                    neutral.hashCode),
                                views.hashCode),
                            originalUrl.hashCode),
                        playbackId.hashCode),
                    image.hashCode),
                channelImage.hashCode),
            createdDate.hashCode),
        expiry.hashCode));
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
          ..add('channelType', channelType)
          ..add('likes', likes)
          ..add('dislikes', dislikes)
          ..add('neutral', neutral)
          ..add('views', views)
          ..add('originalUrl', originalUrl)
          ..add('playbackId', playbackId)
          ..add('image', image)
          ..add('channelImage', channelImage)
          ..add('createdDate', createdDate)
          ..add('expiry', expiry))
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

  String _channelType;
  String get channelType => _$this._channelType;
  set channelType(String channelType) => _$this._channelType = channelType;

  int _likes;
  int get likes => _$this._likes;
  set likes(int likes) => _$this._likes = likes;

  int _dislikes;
  int get dislikes => _$this._dislikes;
  set dislikes(int dislikes) => _$this._dislikes = dislikes;

  int _neutral;
  int get neutral => _$this._neutral;
  set neutral(int neutral) => _$this._neutral = neutral;

  int _views;
  int get views => _$this._views;
  set views(int views) => _$this._views = views;

  String _originalUrl;
  String get originalUrl => _$this._originalUrl;
  set originalUrl(String originalUrl) => _$this._originalUrl = originalUrl;

  String _playbackId;
  String get playbackId => _$this._playbackId;
  set playbackId(String playbackId) => _$this._playbackId = playbackId;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _channelImage;
  String get channelImage => _$this._channelImage;
  set channelImage(String channelImage) => _$this._channelImage = channelImage;

  Timestamp _createdDate;
  Timestamp get createdDate => _$this._createdDate;
  set createdDate(Timestamp createdDate) => _$this._createdDate = createdDate;

  DateTime _expiry;
  DateTime get expiry => _$this._expiry;
  set expiry(DateTime expiry) => _$this._expiry = expiry;

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
      _channelType = _$v.channelType;
      _likes = _$v.likes;
      _dislikes = _$v.dislikes;
      _neutral = _$v.neutral;
      _views = _$v.views;
      _originalUrl = _$v.originalUrl;
      _playbackId = _$v.playbackId;
      _image = _$v.image;
      _channelImage = _$v.channelImage;
      _createdDate = _$v.createdDate;
      _expiry = _$v.expiry;
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
  void update(void Function(TrailerBuilder) updates) {
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
            channelType: channelType,
            likes: likes,
            dislikes: dislikes,
            neutral: neutral,
            views: views,
            originalUrl: originalUrl,
            playbackId: playbackId,
            image: image,
            channelImage: channelImage,
            createdDate: createdDate,
            expiry: expiry);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
