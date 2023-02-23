// This creates an access class to Video files in local device under app directory

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';

class ScrollsManager extends Manager {
  final BuildContext context;
  final Future<String> cachedPath = getOrCreateFolder('scrolls/cached');

  Future<List<Image>> getScrollsImageFromCache(String scrollsName) async {
    List<Image> scrollsImages = [];

    if (!await isCached(scrollsName)) {
      return scrollsImages;
    }

    Directory scrollsDirectory =
        getDirectory(Directory(await cachedPath), scrollsName)!;
    List<String> cachedImagePaths = filePathList(scrollsDirectory);
    scrollsPathSort(cachedImagePaths);
    scrollsImages = await Future.wait(cachedImagePaths.map(
      (imagePath) async {
        return await loadImageToMemory(
            path: imagePath, height: MediaQuery.of(context).size.height);
      },
    ));
    return scrollsImages;
  }

  Future<List<Image>> getScrollsImageFromNetwork(String scrollsName,
      {void Function(dynamic arg)? callback}) async {
    List<Image> scrollsImages = [];

    if (callback != null) {
      scrollsImages = await getScrollsImageFromCache(scrollsName);
      callback(scrollsImages);
      return scrollsImages;
    }

    if (await isCached(scrollsName)) {
      scrollsImages = await getScrollsImageFromCache(scrollsName);
      return scrollsImages;
    } else {
      await downloadScrolls(scrollsName);
      scrollsImages = await getScrollsImageFromCache(scrollsName);
      return scrollsImages;
    }
  }

  Future<void> downloadScrolls(String scrollsName) async {
    return null;
  }

  void scrollsPathSort(List<String> scrollsPaths) {
    return scrollsPaths.sort((a, b) {
      final aFileName = a.split("/").last.split(".").first;
      final bFileName = b.split("/").last.split(".").first;
      return int.parse(aFileName).compareTo(int.parse(bFileName));
    });
  }

  Future<bool> isCached(String scrollsName) async {
    bool cached = false;

    Directory cachedDir = Directory(await cachedPath);

    directoryPathList(cachedDir).forEach((element) {
      if (element.split('/').last == scrollsName) {
        cached = true;
      }
    });

    return cached;
  }

  ScrollsManager({required this.context}) {
    appDirectory().then(
      (value) async {
        @override
        final path = await getOrCreateFolder('${value.path}/scrolls');
        @override
        final directory = Directory(path);
      },
    );
  }
}
