/* 
 * Copyright (c) 2021 fgsoruco.
 * See LICENSE for more details.
 */
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/factory/utils.dart';

///Class for process [Threshold]
class ThresholdFactory {
  static const platform = const MethodChannel('opencv_4');

  static Future<Uint8List?> threshold({
    required CVPathFrom pathFrom,
    required String pathString,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
    Uint8List? data,
  }) async {
    File _file;
    Uint8List _fileAssets;

    Uint8List? result;
    switch (pathFrom) {
      case CVPathFrom.GALLERY_CAMERA:
        result = await platform.invokeMethod('threshold', {
          "pathType": 1,
          "pathString": pathString,
          "data": Uint8List(0),
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });
        break;
      case CVPathFrom.URL:
        _file = await DefaultCacheManager().getSingleFile(pathString);
        result = await platform.invokeMethod('threshold', {
          "pathType": 2,
          "pathString": '',
          "data": await _file.readAsBytes(),
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });

        break;
      case CVPathFrom.ASSETS:
        _fileAssets = await Utils.imgAssets2Uint8List(pathString);
        result = await platform.invokeMethod('threshold', {
          "pathType": 3,
          "pathString": '',
          "data": _fileAssets,
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });
        break;
      case CVPathFrom.LOCAL:
        _file = File(pathString);
        final _fileAssets = await _file.readAsBytes();
        result = await platform.invokeMethod('threshold', {
          "pathType": 4,
          "pathString": '',
          "data": _fileAssets,
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });
        break;
      case CVPathFrom.BYTES:
        result = await platform.invokeMethod('threshold', {
          "pathType": 5,
          "pathString": '',
          "data": data,
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });
        break;
      default:
        _fileAssets = await Utils.imgAssets2Uint8List(pathString);
        result = await platform.invokeMethod('threshold', {
          "pathType": 3,
          "pathString": '',
          "data": _fileAssets,
          'thresholdValue': thresholdValue,
          'maxThresholdValue': maxThresholdValue,
          'thresholdType': thresholdType
        });
    }

    return result;
  }
}
