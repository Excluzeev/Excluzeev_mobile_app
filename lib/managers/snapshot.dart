import 'dart:convert';

import 'package:trenstop/misc/logger.dart';

/// `Snapshot` is a generic class that can receive a serialized String (such as JSON),
/// the deserialized data as the type `T`, and a dynamic error. An error will also occurr
/// if both are null or data is null.
class Snapshot<T> {
  final String serialized;
  final T data;
  final dynamic error;

  bool get hasData => this.data != null || this.serialized != null;

  bool get hasError =>
      (this.data == null && this.error == null) ||
      this.data == null ||
      this.error != null;

  bool get success => this.hasData && !this.hasError;

  Snapshot({this.serialized, this.data, this.error});

  @override
  String toString() =>
      "Snapshot<${T.toString()}>{data: ${data?.toString()}, error: ${error?.toString()}";
}

class ListSnapshot<T> {
  final String serialized;
  List<T> data = [];
  final String error;

  bool get hasData =>
      (this.data != null && this.data.isNotEmpty) || this.serialized != null;

  bool get hasError =>
      (this.data == null && this.error == null) ||
      (this.data == null || this.data.isEmpty) ||
      this.error != null;

  bool get success => this.hasData && !this.hasError;

  ListSnapshot({this.data, this.serialized, this.error});
}

class DocumentCheck<T> {
  final T data;
  final bool exists;

  DocumentCheck({this.data, this.exists});

  @override
  String toString() {
    return "DocumentCheck: $exists, with: $data";
  }
}

class ModelResult {
  final String tag;
  final double value;

  ModelResult(this.tag, this.value);

  @override
  String toString() => "{tag: $tag, value: $value}";

  String get percent => "${(value * 100.0).round()}\%";

  static Map<String, double> convert(List<ModelResult> results) {
    Map<String, double> data = {};
    if (results == null || results.isEmpty) return data;
    results.forEach((item) => data[item.tag] = item.value);
    return data;
  }

  static List<ModelResult> from(Map<String, double> results) {
    List<ModelResult> data = [];
    if (results == null || results.isEmpty) return data;
    results.forEach((key, value) => data.add(ModelResult(key, value)));
    return data;
  }
}

class CompleteResult {
  final List<ModelResult> average;

  final List<List<ModelResult>> results;

  CompleteResult(this.average, this.results)
      : assert(average != null && average.isNotEmpty),
        assert(results != null && results.isNotEmpty);

  int get length => results != null ? results.length : 0;

  bool get isEmpty => length == 0;

  bool get isNotEmpty => !isEmpty;

  Map<String, double> get styleDNA => ModelResult.convert(average);

  List<Map<String, double>> get dnas =>
      results.map((item) => ModelResult.convert(item)).toList();
}

class EngineModel {
  final String name;

  const EngineModel(this.name);

  static const String ENGINE_ENDPOINT = "ml.googleapis.com";
  static const String ENGINE_LABELS = "res/labels/full_labels.txt";

  String get url => "/v1/projects/happyapp-218221/models/$name:predict";

  Uri get uri => Uri.https(ENGINE_ENDPOINT, url);
}

class EnginePayload {
  static const String TAG = "ENGINE_PAYLOAD";

  final List<String> images;

  EnginePayload(this.images);

  Map<String, dynamic> convert(int position, String data) => {
        "image_bytes": {
          "b64": data,
        },
      };

  Map<String, dynamic> get asMap {
    final list = [];

    for (int i = 0; i < images.length; i++) {
      list.add(convert(i, images[i]));
    }

    return {
      "instances": list,
    };
  }

  static List<double> average(List<List<double>> results) {
    if (results == null || results.isEmpty)
      throw RangeError("Can't do average of null or empty list");
    if (results.length == 1) return results.first;

    final length = results.first.length;
    Logger.log(TAG, message: "Averaging $length values");
    final sum = List.generate(length, (position) => 0.0);
    for (List<double> resultList in results) {
      for (int position = 0; position < resultList.length; position++) {
        sum[position] = sum[position] + resultList[position];
      }
    }

    return sum.map((item) => item / results.length).toList();
  }

  String get asJson => json.encode(this.asMap);
}

class AutoMLPayload {
  final String imageBytes;

  AutoMLPayload(this.imageBytes);

  Map<String, dynamic> get asMap => {
        "payload": {
          "image": {"imageBytes": imageBytes}
        }
      };

  String get asJson => json.encode(this.asMap);
}
