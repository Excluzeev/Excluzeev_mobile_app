// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

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

Serializer<Video> _$videoSerializer = new _$VideoSerializer();

class _$VideoSerializer implements StructuredSerializer<Video> {
  @override
  final Iterable<Type> types = const [Video, _$Video];
  @override
  final String wireName = 'Video';

  @override
  Iterable serialize(Serializers serializers, Video object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'videoId',
      serializers.serialize(object.videoId,
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
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
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
    if (object.playbackId != null) {
      result
        ..add('playbackId')
        ..add(serializers.serialize(object.playbackId,
            specifiedType: const FullType(String)));
    }
    if (object.videoUrl != null) {
      result
        ..add('videoUrl')
        ..add(serializers.serialize(object.videoUrl,
            specifiedType: const FullType(String)));
    }
    if (object.channelImage != null) {
      result
        ..add('channelImage')
        ..add(serializers.serialize(object.channelImage,
            specifiedType: const FullType(String)));
    }
    if (object.later != null) {
      result
        ..add('later')
        ..add(serializers.serialize(object.later,
            specifiedType: const FullType(String)));
    }
    if (object.scheduleDate != null) {
      result
        ..add('scheduleDate')
        ..add(serializers.serialize(object.scheduleDate,
            specifiedType: const FullType(Timestamp)));
    }
    if (object.sDate != null) {
      result
        ..add('sDate')
        ..add(serializers.serialize(object.sDate,
            specifiedType: const FullType(String)));
    }
    if (object.streamKey != null) {
      result
        ..add('streamKey')
        ..add(serializers.serialize(object.streamKey,
            specifiedType: const FullType(String)));
    }
    if (object.muxId != null) {
      result
        ..add('muxId')
        ..add(serializers.serialize(object.muxId,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Video deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VideoBuilder();

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
        case 'videoId':
          result.videoId = serializers.deserialize(value,
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
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'playbackId':
          result.playbackId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'videoUrl':
          result.videoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channelImage':
          result.channelImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'later':
          result.later = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'scheduleDate':
          result.scheduleDate = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp)) as Timestamp;
          break;
        case 'sDate':
          result.sDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'streamKey':
          result.streamKey = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'muxId':
          result.muxId = serializers.deserialize(value,
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

class _$Video extends Video {
  @override
  final String userId;
  @override
  final String videoId;
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
  final String type;
  @override
  final String image;
  @override
  final String playbackId;
  @override
  final String videoUrl;
  @override
  final String channelImage;
  @override
  final String later;
  @override
  final Timestamp scheduleDate;
  @override
  final String sDate;
  @override
  final String streamKey;
  @override
  final String muxId;
  @override
  final Timestamp createdDate;

  factory _$Video([void updates(VideoBuilder b)]) =>
      (new VideoBuilder()..update(updates)).build();

  _$Video._(
      {this.userId,
      this.videoId,
      this.channelId,
      this.channelName,
      this.categoryId,
      this.categoryName,
      this.createdBy,
      this.title,
      this.description,
      this.type,
      this.image,
      this.playbackId,
      this.videoUrl,
      this.channelImage,
      this.later,
      this.scheduleDate,
      this.sDate,
      this.streamKey,
      this.muxId,
      this.createdDate})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Video', 'userId');
    }
    if (videoId == null) {
      throw new BuiltValueNullFieldError('Video', 'videoId');
    }
    if (channelId == null) {
      throw new BuiltValueNullFieldError('Video', 'channelId');
    }
    if (channelName == null) {
      throw new BuiltValueNullFieldError('Video', 'channelName');
    }
    if (categoryId == null) {
      throw new BuiltValueNullFieldError('Video', 'categoryId');
    }
    if (categoryName == null) {
      throw new BuiltValueNullFieldError('Video', 'categoryName');
    }
    if (createdBy == null) {
      throw new BuiltValueNullFieldError('Video', 'createdBy');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Video', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Video', 'description');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('Video', 'type');
    }
    if (createdDate == null) {
      throw new BuiltValueNullFieldError('Video', 'createdDate');
    }
  }

  @override
  Video rebuild(void updates(VideoBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoBuilder toBuilder() => new VideoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Video &&
        userId == other.userId &&
        videoId == other.videoId &&
        channelId == other.channelId &&
        channelName == other.channelName &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        createdBy == other.createdBy &&
        title == other.title &&
        description == other.description &&
        type == other.type &&
        image == other.image &&
        playbackId == other.playbackId &&
        videoUrl == other.videoUrl &&
        channelImage == other.channelImage &&
        later == other.later &&
        scheduleDate == other.scheduleDate &&
        sDate == other.sDate &&
        streamKey == other.streamKey &&
        muxId == other.muxId &&
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
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc(0, userId.hashCode),
                                                                                videoId.hashCode),
                                                                            channelId.hashCode),
                                                                        channelName.hashCode),
                                                                    categoryId.hashCode),
                                                                categoryName.hashCode),
                                                            createdBy.hashCode),
                                                        title.hashCode),
                                                    description.hashCode),
                                                type.hashCode),
                                            image.hashCode),
                                        playbackId.hashCode),
                                    videoUrl.hashCode),
                                channelImage.hashCode),
                            later.hashCode),
                        scheduleDate.hashCode),
                    sDate.hashCode),
                streamKey.hashCode),
            muxId.hashCode),
        createdDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Video')
          ..add('userId', userId)
          ..add('videoId', videoId)
          ..add('channelId', channelId)
          ..add('channelName', channelName)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('createdBy', createdBy)
          ..add('title', title)
          ..add('description', description)
          ..add('type', type)
          ..add('image', image)
          ..add('playbackId', playbackId)
          ..add('videoUrl', videoUrl)
          ..add('channelImage', channelImage)
          ..add('later', later)
          ..add('scheduleDate', scheduleDate)
          ..add('sDate', sDate)
          ..add('streamKey', streamKey)
          ..add('muxId', muxId)
          ..add('createdDate', createdDate))
        .toString();
  }
}

class VideoBuilder implements Builder<Video, VideoBuilder> {
  _$Video _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _videoId;
  String get videoId => _$this._videoId;
  set videoId(String videoId) => _$this._videoId = videoId;

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

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _playbackId;
  String get playbackId => _$this._playbackId;
  set playbackId(String playbackId) => _$this._playbackId = playbackId;

  String _videoUrl;
  String get videoUrl => _$this._videoUrl;
  set videoUrl(String videoUrl) => _$this._videoUrl = videoUrl;

  String _channelImage;
  String get channelImage => _$this._channelImage;
  set channelImage(String channelImage) => _$this._channelImage = channelImage;

  String _later;
  String get later => _$this._later;
  set later(String later) => _$this._later = later;

  Timestamp _scheduleDate;
  Timestamp get scheduleDate => _$this._scheduleDate;
  set scheduleDate(Timestamp scheduleDate) =>
      _$this._scheduleDate = scheduleDate;

  String _sDate;
  String get sDate => _$this._sDate;
  set sDate(String sDate) => _$this._sDate = sDate;

  String _streamKey;
  String get streamKey => _$this._streamKey;
  set streamKey(String streamKey) => _$this._streamKey = streamKey;

  String _muxId;
  String get muxId => _$this._muxId;
  set muxId(String muxId) => _$this._muxId = muxId;

  Timestamp _createdDate;
  Timestamp get createdDate => _$this._createdDate;
  set createdDate(Timestamp createdDate) => _$this._createdDate = createdDate;

  VideoBuilder();

  VideoBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _videoId = _$v.videoId;
      _channelId = _$v.channelId;
      _channelName = _$v.channelName;
      _categoryId = _$v.categoryId;
      _categoryName = _$v.categoryName;
      _createdBy = _$v.createdBy;
      _title = _$v.title;
      _description = _$v.description;
      _type = _$v.type;
      _image = _$v.image;
      _playbackId = _$v.playbackId;
      _videoUrl = _$v.videoUrl;
      _channelImage = _$v.channelImage;
      _later = _$v.later;
      _scheduleDate = _$v.scheduleDate;
      _sDate = _$v.sDate;
      _streamKey = _$v.streamKey;
      _muxId = _$v.muxId;
      _createdDate = _$v.createdDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Video other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Video;
  }

  @override
  void update(void updates(VideoBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Video build() {
    final _$result = _$v ??
        new _$Video._(
            userId: userId,
            videoId: videoId,
            channelId: channelId,
            channelName: channelName,
            categoryId: categoryId,
            categoryName: categoryName,
            createdBy: createdBy,
            title: title,
            description: description,
            type: type,
            image: image,
            playbackId: playbackId,
            videoUrl: videoUrl,
            channelImage: channelImage,
            later: later,
            scheduleDate: scheduleDate,
            sDate: sDate,
            streamKey: streamKey,
            muxId: muxId,
            createdDate: createdDate);
    replace(_$result);
    return _$result;
  }
}
