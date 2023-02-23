// This creates an access class to Video files in local device under app directory

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';

class Video {}

class RecordedVideoManager extends Manager {
  final BuildContext? context;
  // cachedPath manages remix videos scrolled by the user
  final Future<String> cachedPath = getOrCreateFolder('videos/recorded');
  // uploadedPath manages videos (mostly mp4s) that are uploaded and being converted to scrolls
  // possible alternative to manual getOrCreateFolder is to set videos to choose from a local gallery
  final Future<String> uploadedPath = getOrCreateFolder(
      'videos/uploaded'); // = getGalleryFolder(); -> in case of choosing from local gallery
  // Converter should be managed by its parent
  final Converter converter;

  void saveRemix(RemixModel remixModel) async {
    if (remixModel.getPath() != null) {
      // This saves the path to the remixModel again
      // This will also override the original path
      return;
    }

    String remixPath = '${await cachedPath}/${remixModel.getTitle()}';

    remixPath = await resolveDirectoryPath(remixPath);
    String remixTitle = remixPath.split('/').last;
    print(remixPath);
    remixModel.setPath(remixPath);
    remixModel.setTitle(remixTitle);
    converter.convertRemixToVideo(remixModel, remixPath);
  }

  Video? getRemixVideoFromRemix(RemixModel remixModel) {
    if (remixModel.getPath() == '') {
      return null;
    }
    return null;
  }

  Future<bool> isCached(String remixName) async {
    bool cached = false;

    Directory cachedDir = Directory(await cachedPath);

    directoryPathList(cachedDir).forEach((element) {
      if (element.split('/').last == remixName) {
        cached = true;
      }
    });

    return cached;
  }

  RecordedVideoManager({this.context, required this.converter}) {
    appDirectory().then(
      (value) async {
        path = await getOrCreateFolder('${value.path}/videos/recorded');
        directory = Directory(path);
      },
    );
  }
}
