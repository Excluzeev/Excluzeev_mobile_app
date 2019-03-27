import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:trenstop/models/category.dart';
import 'package:trenstop/models/channel.dart';
import 'package:trenstop/models/chat.dart';
import 'package:trenstop/models/comments.dart';
import 'package:trenstop/models/trailer.dart';
import 'package:trenstop/models/user.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  User,
  Category,
  Channel,
  Trailer,
  Comments,
  Chat,
])
final Serializers serializers =
(_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();