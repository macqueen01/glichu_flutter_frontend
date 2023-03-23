import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:tar/tar.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:mockingjae2_mobile/src/settings.dart';

class ScrollsFetcher {
  BaseUrl backendUrls = BaseUrl();
  bool fetchReady = false;

  final Directory baseDir;

  ScrollsFetcher({required this.baseDir}) {
    // Initialize downloader (only once)
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(debug: true).then((result) {
      fetchReady = true;
    });
  }

  Future<void> fetch(scrollsId) async {
    if (!fetchReady) {
      return;
    }

    final browseUrl =
        Uri.parse(backendUrls.scrollsBrowseUrl + '?id=$scrollsId');
    final response = await get(browseUrl);

    if (response.statusCode == HttpStatus.ok) {
      final tarBytes = response.bodyBytes;
      final reader = TarReader(Stream.fromIterable([tarBytes]));
      while (await reader.moveNext()) {
        final file = reader.current;
        final filePath = '${baseDir.path}/${file.name}';
        if (file.header.typeFlag != TypeFlag.dir) {
          await File(filePath)
              .writeAsBytes(await reader.current.contents.toBytes());
        } else if (file.header.typeFlag != TypeFlag.dir) {
          await Directory(filePath).create(recursive: true);
        }
      }
    } else {
      throw Exception('Failed to download tar file: ${response.statusCode}');
    }
  }
}
