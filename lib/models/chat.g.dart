// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

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

Serializer<Chat> _$chatSerializer = new _$ChatSerializer();

class _$ChatSerializer implements StructuredSerializer<Chat> {
  @override
  final Iterable<Type> types = const [Chat, _$Chat];
  @override
  final String wireName = 'Chat';

  @override
  Iterable serialize(Serializers serializers, Chat object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'chatId',
      serializers.serialize(object.chatId,
          specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'userName',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
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
  Chat deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatBuilder();

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
        case 'chatId':
          result.chatId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userPhoto':
          result.userPhoto = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userName':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(Timestamp)) as Timestamp;
          break;
      }
    }

    return result.build();
  }
}

class _$Chat extends Chat {
  @override
  final String userId;
  @override
  final String chatId;
  @override
  final String userPhoto;
  @override
  final String message;
  @override
  final String userName;
  @override
  final Timestamp createdAt;

  factory _$Chat([void updates(ChatBuilder b)]) =>
      (new ChatBuilder()..update(updates)).build();

  _$Chat._(
      {this.userId,
      this.chatId,
      this.userPhoto,
      this.message,
      this.userName,
      this.createdAt})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('Chat', 'userId');
    }
    if (chatId == null) {
      throw new BuiltValueNullFieldError('Chat', 'chatId');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('Chat', 'message');
    }
    if (userName == null) {
      throw new BuiltValueNullFieldError('Chat', 'userName');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Chat', 'createdAt');
    }
  }

  @override
  Chat rebuild(void updates(ChatBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatBuilder toBuilder() => new ChatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chat &&
        userId == other.userId &&
        chatId == other.chatId &&
        userPhoto == other.userPhoto &&
        message == other.message &&
        userName == other.userName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, userId.hashCode), chatId.hashCode),
                    userPhoto.hashCode),
                message.hashCode),
            userName.hashCode),
        createdAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Chat')
          ..add('userId', userId)
          ..add('chatId', chatId)
          ..add('userPhoto', userPhoto)
          ..add('message', message)
          ..add('userName', userName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ChatBuilder implements Builder<Chat, ChatBuilder> {
  _$Chat _$v;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _chatId;
  String get chatId => _$this._chatId;
  set chatId(String chatId) => _$this._chatId = chatId;

  String _userPhoto;
  String get userPhoto => _$this._userPhoto;
  set userPhoto(String userPhoto) => _$this._userPhoto = userPhoto;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  String _userName;
  String get userName => _$this._userName;
  set userName(String userName) => _$this._userName = userName;

  Timestamp _createdAt;
  Timestamp get createdAt => _$this._createdAt;
  set createdAt(Timestamp createdAt) => _$this._createdAt = createdAt;

  ChatBuilder();

  ChatBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _chatId = _$v.chatId;
      _userPhoto = _$v.userPhoto;
      _message = _$v.message;
      _userName = _$v.userName;
      _createdAt = _$v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Chat other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Chat;
  }

  @override
  void update(void updates(ChatBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Chat build() {
    final _$result = _$v ??
        new _$Chat._(
            userId: userId,
            chatId: chatId,
            userPhoto: userPhoto,
            message: message,
            userName: userName,
            createdAt: createdAt);
    replace(_$result);
    return _$result;
  }
}
