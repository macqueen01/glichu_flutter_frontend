import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:tar/tar.dart';
import 'package:dio/dio.dart' as dio;

import 'package:mockingjae2_mobile/src/settings.dart';

class AutoRecorderApi {
  BaseUrl backendUrls = BaseUrl();

  dio.Dio dioClient = dio.Dio();

  Future<void> uploadRemix(RemixModel autoRecordingRemixModel) async {
    try {
      dio.Response response = await dioClient.post(
          backendUrls.autoRecordingUrls.remixUploadUrl,
          data: autoRecordingRemixModel.toJson());
    } catch (e) {
      print(e);
    }
  }
}
