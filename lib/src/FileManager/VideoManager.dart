// This creates an access class to Video files in local device under app directory

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class RemixPlayManager extends RecordedVideoManager {
  List<File> _remixVideos = [];
  int currentIndex = 0;

  File getRemix(int index) {
    // assume index is in range
    return _remixVideos[index];
  }

  void setIndex(int index) {
    this.currentIndex = index;
    //_resetAllVideos();
    notifyListeners();
  }

  bool isEmpty() {
    return _remixVideos.isEmpty;
  }

  int? lastIndex() {
    if (isEmpty()) {
      return null;
    }
    return _remixVideos.length - 1;
  }

  int num_scrolls() {
    return _remixVideos.length;
  }

  void addRemixVideo(File video) {
    _remixVideos.add(video);
  }

  void addAllRemixVideos(List<File> videos) {
    _remixVideos.addAll(videos);
    notifyListeners();
  }
}

class RecordedVideoManager extends ChangeNotifier {
  final BuildContext? context;
  // cachedPath manages remix videos scrolled by the user
  final Future<String> cachedPath = getOrCreateFolder('videos/recorded');
  // uploadedPath manages videos (mostly mp4s) that are uploaded and being converted to scrolls
  // possible alternative to manual getOrCreateFolder is to set videos to choose from a local gallery
  final Future<String> uploadedPath = getOrCreateFolder(
      'videos/uploaded'); // = getGalleryFolder(); -> in case of choosing from local gallery
  // Converter should be managed by its parent
  Converter? converter;
  VideoPlayerController? videoPlayerController;

  void saveRemix(RemixModel remixModel) async {
    if (remixModel.getPath() != null) {
      // This saves the path to the remixModel again
      // This will also override the original path
      return;
    }

    String remixPath = '${await cachedPath}/${remixModel.getTitle()}.mp4';

    remixPath = await resolveFilePath(remixPath);
    String remixTitle = remixPath.split('/').last;
    remixModel.setPath(remixPath);
    remixModel.setTitle(remixTitle);
    converter!.convertRemixToVideo(remixModel, remixPath);
  }

  Future<List<File>> getAllRemixes() async {
    List<File> cachedRemixes = fileList(Directory(await cachedPath));
    return cachedRemixes;
  }

  Future<List<File>> getRemixVideoFromRemix(String remixName) async {
    List<File> remixList = [];

    for (File remix in await getAllRemixes()) {
      if (videoPathToRemixName(remix.path) == remixName) {
        remixList.add(remix);
      }
    }
    return remixList;
  }

  Future<bool> isCached(String remixName) async {
    bool cached = false;

    Directory cachedDir = Directory(await cachedPath);

    directoryPathList(cachedDir).forEach((element) {
      if (videoPathToRemixName(element) == remixName) {
        cached = true;
      }
    });

    return cached;
  }

  String videoPathToRemixName(String videoPath) {
    String remixName = videoPath
        .split('/')
        .last // get only basename
        .split('.')
        .first // get file name without extension
        .split('(')
        .first; // get original remix name without numbering... multiple videos may detected
    return remixName;
  }

  RecordedVideoManager(
      {this.context,
      this.converter = null,
      this.videoPlayerController = null}) {
    if (converter == null) {
      this.converter = Converter();
    }

    appDirectory().then(
      (value) async {
        @override
        final path = await getOrCreateFolder('${value.path}/videos');
        @override
        final directory = Directory(path);
      },
    );
  }
}
