import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:tar/tar.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
    if (!FlutterDownloader.initialized) {
      await FlutterDownloader.initialize(debug: true);
    }
    fetchReady = true;
  }

  Future<void> fetch(String scrollsName) async {
    if (!fetchReady) {
      // if not ready, reinitalize
      await init();
    }

    final int scrollsId = getScrollsId(scrollsName);
    final String scrollsUrl = '${backendUrls.scrollsBrowseUrl}id$scrollsId.tar';

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

  ScrollsHeaderFetcher() {}

  Future<List<ScrollsModel>> fetch() async {
    final browseUrl = Uri.parse(backendUrls.scrollsBrowseUrl);
    final response = await get(browseUrl);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> scrollsList = json.decode(response.body);
      return scrollsList.map((e) => ScrollsModel.fromMap(e)).toList();
    } else {
      throw Exception('Failed to download tar file: ${response.statusCode}');
    }
  }
}
