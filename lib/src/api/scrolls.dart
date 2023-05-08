import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:tar/tar.dart';
import 'package:dio/dio.dart' as dio;

import 'package:mockingjae2_mobile/src/settings.dart';

class ScrollsContentFetcher {
  BaseUrl backendUrls = BaseUrl();
  bool fetchReady = false;

  final Directory baseDir;

  ScrollsContentFetcher({required this.baseDir}) {
    // Initialize downloader (only once)
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> init() async {
    fetchReady = true;
  }

  Future<void> fetch(String scrollsName) async {
    if (!fetchReady) {
      // if not ready, reinitalize
      await init();
    }

    final int scrollsId = getScrollsId(scrollsName);
    final String scrollsUrl = '${backendUrls.scrollsFetchUrl}id$scrollsId.tar';

    // final browseUrl = Uri.parse(backendUrls.scrollsBrowseUrl + '?id=$scrollsId');
    final browseUrl = Uri.parse(scrollsUrl);
    final response = await get(browseUrl);

    if (response.statusCode == HttpStatus.ok) {
      final tarBytes = response.bodyBytes;
      await unpackTarToDir(baseDir, tarBytes);
    } else {
      throw Exception('Failed to download tar file: ${response.statusCode}');
    }
  }
}

Future<void> unpackTarToDir(Directory baseDir, Uint8List bytes) async {
  // check if the given bytes (Uint8array) is a tar file
  // if not, throw an exception
  final reader = TarReader(Stream.fromIterable([bytes]));

  // check if the reader is valid
  // if ()
  while (await reader.moveNext()) {
    TarEntry file = reader.current;
    String filePath = '${baseDir.path}/${file.name}';
    String parentDir = Directory(filePath).parent.path;
    if (!await Directory(parentDir).exists()) {
      await Directory(parentDir).create(recursive: true);
    }
    if (file.header.typeFlag != TypeFlag.dir) {
      File(filePath).writeAsBytes(await reader.current.contents.toBytes());
    } else if (file.header.typeFlag != TypeFlag.dir) {
      await Directory(filePath).create(recursive: true);
    }
  }
}

class ScrollsHeaderFetcher {
  BaseUrl backendUrls = BaseUrl();

  Future<ScrollsModel> singleFetch() async {
    final browseUrl = Uri.parse(backendUrls.scrollsBrowseUrls.baseUrl);
    final response = await get(browseUrl);

    if (response.statusCode == HttpStatus.ok) {
      final dynamic scrolls = json.decode(response.body);

      ScrollsModel scrollsModel = ScrollsModel(
          highlightIndexList: [],
          isRestricted: false,
          scrollsName: '${scrolls['id']}_${scrolls['title']}');
      return scrollsModel;
    } else {
      throw Exception('Failed to download tar file: ${response.statusCode}');
    }
  }
}

class ScrollsUploader {
  BaseUrl backendUrls = BaseUrl();

  dio.Dio dioClient = dio.Dio();

  String videoUploadTaskId = '';
  String scrollifyTaskId = '';
  String scrollsUploadTaskId = '';
  int? scrollsId;

  File currentLoadedVideo;
  int hashedVideoFile = 0;

  ScrollsUploader({
    required this.currentLoadedVideo,
  }) {
    hashedVideoFile = currentLoadedVideo.hashCode;
  }

  File currentLoadedVideoFile() {
    return currentLoadedVideo;
  }

  Future<bool> isTaskComplete(String taskId) async {
    if (taskId == '') {
      return false;
    }

    try {
      dio.Response response = await dioClient.post(
          backendUrls.scrollsUploadUrls.getTaskStatus,
          data: {'task_id': taskId});

      if (int.parse(response.data['status']) == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // With following input, upload a video file to the backend

  Future<Map?> _uploadVideoFileAPI(File videoFile, String fileName) async {
    fileName = '$fileName.${fileExtension(videoFile)}';

    dio.FormData formData = dio.FormData.fromMap({
      'video_to_upload':
          await dio.MultipartFile.fromFile(videoFile.path, filename: fileName),
      'title': fileName
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.scrollsUploadUrls.videoUpload, data: formData);
      print(response.data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map?> _scrollifyVideoAPI(String videoUploadTaskId, String title,
      int height, int quality, int fps) async {
    dio.FormData formData = dio.FormData.fromMap({
      'task_id': videoUploadTaskId,
      'title': title,
      'height': height,
      'quality': quality,
      'fps': fps
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.scrollsUploadUrls.scrollify, data: formData);
      print(response.data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map?> _uploadScrollsAPI(String scrollifyTaskId, int scrollsId) async {
    dio.FormData formData = dio.FormData.fromMap({
      'task_id': scrollifyTaskId,
      'scrolls_id': scrollsId,
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.scrollsUploadUrls.scrollsUpload, data: formData);
      print(response.data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  bool _isValidResponse(Map response, List<String> keys) {
    for (String key in keys) {
      if (!response.containsKey(key) || response[key] == null) {
        return false;
      }
    }
    return true;
  }

  void setVideoUploadTaskId(String taskId) {
    videoUploadTaskId = taskId;
  }

  void setScrollifyTaskId(String taskId) {
    scrollifyTaskId = taskId;
  }

  void setScrollsUploadTaskId(String taskId) {
    scrollsUploadTaskId = taskId;
  }

  void setScrollsId(int scrollsId) {
    this.scrollsId = scrollsId;
  }

  Future<void> uploadVideoFile() async {
    Map? response = await _uploadVideoFileAPI(
        this.currentLoadedVideo, this.hashedVideoFile.toString());
    if (_isValidResponse(response!, ['task_id'])) {
      setVideoUploadTaskId(response['task_id']);
    }

    print(response);
  }

  Future<void> scrollifyVideo(
      String title, int height, int quality, int fps) async {
    if (videoUploadTaskId == '') {
      throw Exception('Video upload task id is not set');
    }

    Map? response = await _scrollifyVideoAPI(
        videoUploadTaskId, title, height, quality, fps);

    if (_isValidResponse(response!, ['task_id', 'scrolls_id'])) {
      setScrollifyTaskId(response['task_id']);
      setScrollsId(response['scrolls_id']);
    }
  }

  Future<void> uploadScrolls() async {
    if (videoUploadTaskId == '') {
      throw Exception('Video upload task id is not set');
    }

    if (scrollifyTaskId == '') {
      throw Exception('Scrollify task id is not set');
    }

    if (scrollsId == null) {
      throw Exception('Scrolls id is not set');
    }

    Map? response = await _uploadScrollsAPI(scrollifyTaskId, scrollsId!);

    if (_isValidResponse(response!, ['task_id'])) {
      setScrollsUploadTaskId(response['task_id']);
    }
  }
}
