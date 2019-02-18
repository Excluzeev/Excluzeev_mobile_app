// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

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

Serializer<Comments> _$commentsSerializer = new _$CommentsSerializer();

class _$CommentsSerializer implements StructuredSerializer<Comments> {
  @override
  final Iterable<Type> types = const [Comments, _$Comments];
  @override
  final String wireName = 'Comments';

  @override
  Iterable serialize(Serializers serializers, Comments object,
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
      'commentId',
      serializers.serialize(object.commentId,
          specifiedType: const FullType(String)),
      'comment',
      serializers.serialize(object.comment,
          specifiedType: const FullType(String)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'createdDate',
      serializers.serialize(object.createdDate,
          specifiedType: const FullType(Timestamp)),
    ];
    if (object.userPhoto != null) {
      result
        ..add('userPhoto')
        ..add(serializers.serialize(object.userPhoto,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Comments deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentsBuilder();

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
        case 'commentId':
          result.commentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userPhoto':
          result.userPhoto = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
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

class _$Comments extends Comments {
  @override
  final String userId;
  @override
  final String trailerId;
  @override
  final String channelId;
  @override
  final String channelName;
  @override
  final String commentId;
  @override
  final String userPhoto;
  @override
  final String comment;
  @override
  final String userName;
  @override
  final Timestamp createdDate;

  factory _$Comments([void updates(CommentsBuilder b)]) =>
      (new CommentsBuilder()..update(updates)).build();

  _$Comments._(
      {this.userId,
      this.trailerId,
      this.channelId,
      this.channelName,
      this.commentId,
      this.userPhoto,
      this.comment,
      this.userName,
      this.createdDate})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Comments', 'userId');
    }
    if (trailerId == null) {
      throw new BuiltValueNullFieldError('Comments', 'trailerId');
    }
    if (channelId == null) {
      throw new BuiltValueNullFieldError('Comments', 'channelId');
    }
    if (channelName == null) {
      throw new BuiltValueNullFieldError('Comments', 'channelName');
    }
    if (commentId == null) {
      throw new BuiltValueNullFieldError('Comments', 'commentId');
    }
    if (comment == null) {
      throw new BuiltValueNullFieldError('Comments', 'comment');
    }
    if (userName == null) {
      throw new BuiltValueNullFieldError('Comments', 'userName');
    }
    if (createdDate == null) {
      throw new BuiltValueNullFieldError('Comments', 'createdDate');
    }
  }

  @override
  Comments rebuild(void updates(CommentsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentsBuilder toBuilder() => new CommentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Comments &&
        userId == other.userId &&
        trailerId == other.trailerId &&
        channelId == other.channelId &&
        channelName == other.channelName &&
        commentId == other.commentId &&
        userPhoto == other.userPhoto &&
        comment == other.comment &&
        userName == other.userName &&
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
                                $jc($jc(0, userId.hashCode),
                                    trailerId.hashCode),
                                channelId.hashCode),
                            channelName.hashCode),
                        commentId.hashCode),
                    userPhoto.hashCode),
                comment.hashCode),
            userName.hashCode),
        createdDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Comments')
          ..add('userId', userId)
          ..add('trailerId', trailerId)
          ..add('channelId', channelId)
          ..add('channelName', channelName)
          ..add('commentId', commentId)
          ..add('userPhoto', userPhoto)
          ..add('comment', comment)
          ..add('userName', userName)
          ..add('createdDate', createdDate))
        .toString();
  }
}

class CommentsBuilder implements Builder<Comments, CommentsBuilder> {
  _$Comments _$v;

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

  String _commentId;
  String get commentId => _$this._commentId;
  set commentId(String commentId) => _$this._commentId = commentId;

  String _userPhoto;
  String get userPhoto => _$this._userPhoto;
  set userPhoto(String userPhoto) => _$this._userPhoto = userPhoto;

  String _comment;
  String get comment => _$this._comment;
  set comment(String comment) => _$this._comment = comment;

  String _userName;
  String get userName => _$this._userName;
  set userName(String userName) => _$this._userName = userName;

  Timestamp _createdDate;
  Timestamp get createdDate => _$this._createdDate;
  set createdDate(Timestamp createdDate) => _$this._createdDate = createdDate;

  CommentsBuilder();

  CommentsBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _trailerId = _$v.trailerId;
      _channelId = _$v.channelId;
      _channelName = _$v.channelName;
      _commentId = _$v.commentId;
      _userPhoto = _$v.userPhoto;
      _comment = _$v.comment;
      _userName = _$v.userName;
      _createdDate = _$v.createdDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Comments other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Comments;
  }

  @override
  void update(void updates(CommentsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Comments build() {
    final _$result = _$v ??
        new _$Comments._(
            userId: userId,
            trailerId: trailerId,
            channelId: channelId,
            channelName: channelName,
            commentId: commentId,
            userPhoto: userPhoto,
            comment: comment,
            userName: userName,
            createdDate: createdDate);
    replace(_$result);
    return _$result;
  }
}
