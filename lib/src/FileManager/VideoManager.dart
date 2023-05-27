// This creates an access class to Video files in local device under app directory

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/AutoRecordingPlayer/autoRecordingMessage.dart';
import 'package:mockingjae2_mobile/src/AutoRecordingPlayer/controller.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:mockingjae2_mobile/src/api/message.dart';
import 'package:mockingjae2_mobile/src/api/remix.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

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

class AutoRecordingPlayManager extends ChangeNotifier {
  List<RemixViewModel> _remixViewModels = [];
  int scrollsId;
  Controller? controller;
  AutoRecorderApi autoRecorderApi = AutoRecorderApi();
  MessageApi messageApi = MessageApi();
  int currentIndex = 0;
  int length = 0;
  bool isLoading = false;
  int page = 1;

  // Category
  // category == 0 -> callByRecent (default)
  // category == 1 -> callByMostScrolled
  // category == 2 -> callByFollowers
  int category = 0;

  RemixViewModel getRemix(int index) {
    // assume index is in range
    return _remixViewModels[index];
  }

  RemixViewModel getRemixViewModel(int index) {
    return _remixViewModels[index];
  }

  void addMessage(String message, UserMin commenter, UserMin commentee) {
    RemixViewModel currentModel = getRemixViewModel(currentIndex);

    if (currentModel.messageModel == null) {
      currentModel.messageModel = AutoRecordingMessage(
          remixId: currentModel.remixId,
          commenter: commenter,
          commentee: commentee);
    }

    currentModel.messageModel!.updateMessage(message);
    notifyListeners();
  }

  Future<bool> pushMessage() async {
    RemixViewModel currentModel = getRemixViewModel(currentIndex);

    if (currentModel.messageModel == null) {
      return false;
    }

    await messageApi.pushAutoRecordingMessage(currentModel.messageModel!);

    notifyListeners();
    return true;
  }

  void setIndex(int index) {
    this.currentIndex = index;
    //_resetAllVideos();
    notifyListeners();
  }

  bool isEmpty() {
    return _remixViewModels.isEmpty;
  }

  int? lastIndex() {
    if (isEmpty()) {
      return null;
    }
    return _remixViewModels.length - 1;
  }

  int num_scrolls() {
    return _remixViewModels.length;
  }

  void addRemixVideo(RemixViewModel remix) {
    _remixViewModels.add(remix);
  }

  void addAllRemixVideos(List<RemixViewModel> remixes) {
    _remixViewModels.addAll(remixes);
    length = _remixViewModels.length;
    isLoading = false;
    notifyListeners();
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success) {
    if (lastIndex() == null) {
      return;
    }

    if (success == ScrollSuccess.SUCCESS) {
      if (direction == ScrollDirection.BACKWARDS) {
        if (currentIndex > 0) {
          currentIndex--;
        }
      } else if (direction == ScrollDirection.FORWARD) {
        if (currentIndex < lastIndex()!) {
          currentIndex++;
        }
      }
    }
  }

  void _reset() {
    _remixViewModels = [];
    currentIndex = 0;
    page = 1;
    length = 0;
  }

  void callByRecent({int page = 1, bool reset = false}) {
    isLoading = true;

    if (reset) {
      _reset();
    }

    autoRecorderApi
        .fetchRemixFromScrollsIdByRecent(scrollsId, page)
        .then((remixes) {
      if (remixes == []) {
        isLoading = false;
        return null;
      }

      addAllRemixVideos(remixes);

      category = 0;
      isLoading = false;
      page++;
      controller!.animateToPosition(0);

      notifyListeners();
    });
  }

  void callByMostScrolled({int page = 1, bool reset = false}) {
    isLoading = true;

    if (reset) {
      _reset();
    }

    autoRecorderApi
        .fetchRemixFromScrollsIdByMostScrolled(scrollsId, page)
        .then((remixes) {
      if (remixes == []) {
        isLoading = false;
        return null;
      }

      addAllRemixVideos(remixes);

      category = 0;
      isLoading = false;
      page++;
      controller!.animateToPosition(0);

      notifyListeners();
    });
  }

  void callByFollowers({int page = 1, bool reset = false}) {
    isLoading = true;

    if (reset) {
      _reset();
    }

    autoRecorderApi
        .fetchRemixFromScrollsIdByFollowers(scrollsId, page)
        .then((remixes) {
      if (remixes == []) {
        isLoading = false;
        return null;
      }

      if (reset) {
        _reset();
      }

      addAllRemixVideos(remixes);

      category = 0;
      isLoading = false;
      page++;
      controller!.animateToPosition(0);

      notifyListeners();
    });
  }

  void callNextPage() {
    if (category == 0) {
      callByRecent(page: page);
    } else if (category == 1) {
      callByMostScrolled(page: page);
    } else {
      callByFollowers(page: page);
    }
  }

  List<RemixViewModel> listRemixViewModels() {
    return _remixViewModels;
  }

  void Sample(String string) {
    return null;
  }

  AutoRecordingPlayManager({required this.scrollsId}) {
    isLoading = true;

    if (scrollsId != null) {
      callByRecent(page: page, reset: true);
    }

    controller = Controller()
      ..addListener((event) {
        _handleCallbackEvent(event.direction, event.success);
      });
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
  int? scrollsId;
  AutoRecorderApi autoRecorderApi = AutoRecorderApi();

  void saveRemix(RemixModel remixModel, Future<String?> token) async {
    if (remixModel.getPath() != null) {
      // This saves the path to the remixModel again
      // This will also override the original path
      return;
    }

    String remixPath = '${await cachedPath}/${remixModel.getTitle()}.mp4';
    String? authToken = await token;

    if (authToken == null) {
      return;
    }

    remixPath = await resolveFilePath(remixPath);
    String remixTitle = remixPath.split('/').last;
    remixModel.setPath(remixPath);
    remixModel.setTitle(remixTitle);
    autoRecorderApi.uploadRemix(remixModel, authToken);
    // converter!.convertRemixToVideo(remixModel, remixPath);
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
      this.videoPlayerController = null,
      this.scrollsId}) {
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
