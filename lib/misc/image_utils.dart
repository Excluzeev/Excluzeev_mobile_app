import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:trenstop/managers/snapshot.dart';
import 'package:trenstop/misc/logger.dart';
import 'package:trenstop/widgets/image_loader.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class PhotoPayload {
  final String name;
  final File file;
  final Directory directory;
  final int size;

  PhotoPayload(this.name, this.file, this.directory, this.size);
}

class ModelPayload {
  final File image;
  final int desiredSize;
  final bool isFloat;

  ModelPayload(this.image, this.desiredSize, {this.isFloat = false});
}

class ImageUtils {
  static const String TAG = "IMAGE_UTILS";
  static const int COMPRESSION_VALUE = 80;
  static const int QUALITY_VALUE = 90;

  static Uint8List fileToByteListFloat(File file, int size) {
    final image = img.decodeJpg(file.readAsBytesSync());
    return imageToFloatList(image, size);
  }

  static Uint8List imageToFloatList(img.Image image, int size) {
    var convertedBytes = Float32List(1 * size * size * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        var pixel = image.getPixel(i, j);
        buffer[pixelIndex] = ((pixel >> 16) & 0xFF) / 255;
        pixelIndex += 1;
        buffer[pixelIndex] = ((pixel >> 8) & 0xFF) / 255;
        pixelIndex += 1;
        buffer[pixelIndex] = ((pixel) & 0xFF) / 255;
        pixelIndex += 1;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  static Uint8List imageToByteList(img.Image image, int size) {
    var convertedBytes = Uint8List(1 * size * size * 3);
    var buffer = ByteData.view(convertedBytes.buffer);
    int pixelIndex = 0;
    try {
      for (var i = 0; i < size; i++) {
        for (var j = 0; j < size; j++) {
          var pixel = image.getPixel(i, j);
          buffer.setUint8(pixelIndex++, (pixel >> 16) & 0xFF);
          buffer.setUint8(pixelIndex++, (pixel >> 8) & 0xFF);
          buffer.setUint8(pixelIndex++, (pixel) & 0xFF);
        }
      }
      return convertedBytes;
    } catch (error) {
      Logger.log(TAG,
          message: "Couldn't convert to int Uint8List, error: $error");
      return null;
    }
  }

  static Uint8List prepareAnalysis(ModelPayload payload) {
    img.Image resized = img.decodeJpg(payload.image.readAsBytesSync());
    Logger.log(TAG,
        message:
            "Loaded image's dimensions: ${resized.height}x${resized.width}");
    if (resized.height != payload.desiredSize ||
        resized.width != payload.desiredSize)
      resized =
          img.copyResize(resized, payload.desiredSize, payload.desiredSize);
    Logger.log(TAG,
        message:
            "Resized image's dimensions: ${resized.height}x${resized.width}");
    return (payload.isFloat)
        ? imageToFloatList(resized, payload.desiredSize)
        : imageToByteList(resized, payload.desiredSize);
  }

  static Future<String> byteToBase64(Uint8List bytes) async {
    try {
      return base64Encode(bytes);
    } catch (exception) {
      Logger.log(TAG,
          message: "Couldn't convert Uint8List to Base64, error: $exception");
      return null;
    }
  }

  static String toBase64Sync(File file) {
    try {
      final bytes = file.readAsBytesSync();
      return base64Encode(bytes);
    } catch (exception) {
      Logger.log(TAG,
          message: "Couldn't convert file to Base64, error: $exception");
      return null;
    }
  }

  static Future<String> toBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return byteToBase64(bytes);
    } catch (exception) {
      Logger.log(TAG,
          message: "Couldn't convert file to Base64, error: $exception");
      return null;
    }
  }

  static Future<Snapshot<File>> nativeResize(File file, int size,
      {bool centerCrop = false}) async {
    String error;

    final errorHandler = (exception, stacktrace) {
      error = exception.toString();
      Logger.log(TAG,
          message: "Couldn't resize and compress image, error: $error");
      return null;
    };

    try {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file.path);

      if (centerCrop) {
        if (properties.height > properties.width) {
          file = await FlutterNativeImage.cropImage(
            file.path,
            0,
            (properties.width - properties.height / 2).round(),
            properties.width,
            properties.width,
          ).catchError(errorHandler);
        } else if (properties.width > properties.height) {
          file = await FlutterNativeImage.cropImage(
            file.path,
            (properties.height - properties.width / 2).round(),
            0,
            properties.height,
            properties.height,
          ).catchError(errorHandler);
        }
      }

      if (properties.height > properties.width) {
        file = await FlutterNativeImage.compressImage(
          file.path,
          percentage: COMPRESSION_VALUE,
          quality: QUALITY_VALUE,
          targetHeight: size,
          targetWidth: (properties.width * size / properties.height).round(),
        ).catchError(errorHandler);
      } else if (properties.width > properties.height) {
        file = await FlutterNativeImage.compressImage(
          file.path,
          percentage: COMPRESSION_VALUE,
          quality: QUALITY_VALUE,
          targetWidth: size,
          targetHeight: (properties.height * size / properties.width).round(),
        ).catchError(errorHandler);
      } else {
        file = await FlutterNativeImage.compressImage(
          file.path,
          percentage: COMPRESSION_VALUE,
          quality: QUALITY_VALUE,
          targetWidth: size,
          targetHeight: size,
        ).catchError(errorHandler);
      }
    } catch (exception) {
      error = exception.toString();
      Logger.log(TAG,
          message: "Couldn't resize and compress image, error: $error");
    }

    return Snapshot<File>(
      data: file,
      error: error,
    );
  }

  static File cropResizeImage(PhotoPayload payload) {
    img.Image converted = img.decodeImage(payload.file.readAsBytesSync());

    if (converted.height > converted.width) {
      converted = img.copyCrop(
        converted,
        0,
        (converted.width - converted.height / 2).round(),
        converted.width,
        converted.width,
      );
    } else if (converted.width > converted.height) {
      converted = img.copyCrop(
        converted,
        (converted.height - converted.width / 2).round(),
        0,
        converted.height,
        converted.height,
      );
    }

    converted = img.copyResize(converted, payload.size, payload.size);

    final resized = File("${payload.directory.path}/${payload.name}");
    resized.writeAsBytesSync(img.encodeJpg(converted, quality: QUALITY_VALUE));
    return resized;
  }

  static File resizeImage(PhotoPayload payload) {
    img.Image converted = img.decodeImage(payload.file.readAsBytesSync());
    converted = img.copyResize(converted, payload.size);
    final resized = File("${payload.directory.path}/${payload.name}");
    resized.writeAsBytesSync(img.encodeJpg(converted, quality: QUALITY_VALUE));
    return resized;
  }

  static File resizeSquareImage(PhotoPayload payload) {
    img.Image converted = img.decodeImage(payload.file.readAsBytesSync());
    converted = img.copyResize(converted, payload.size, payload.size);
    final resized = File("${payload.directory.path}/${payload.name}");
    resized.writeAsBytesSync(img.encodeJpg(converted, quality: QUALITY_VALUE));
    return resized;
  }

  static Future<File> downloadImage(String url) async {
    return await DefaultCacheManager()
        .getSingleFile(url)
        .catchError((error, stacktrace) {
      Logger.log(TAG, message: "Couldn't download file: $error");
      return null;
    }).then((file) {
      Logger.log(TAG, message: "Successfully downloaded file!");
      return file;
    });
  }

  static Future<Snapshot<File>> resizePost(
      String uid, File image, int size) async {
    String error;
    File resized;

    final directory = await getTemporaryDirectory();
    try {
      resized = await compute(
        resizeImage,
        PhotoPayload(
          "$uid.jpg",
          image,
          directory,
          size,
        ),
      );
    } catch (exception) {
      Logger.log(TAG,
          message: "Couldn't resize image with uid ($uid), error: $exception");
      error = exception.toString();
    }

    return Snapshot<File>(
      data: resized,
      error: error,
    );
  }

}