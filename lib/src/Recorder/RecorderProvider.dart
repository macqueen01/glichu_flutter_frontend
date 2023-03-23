// This creates an access class to Video files in local device under app directory

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/Recorder/recorder.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class RecorderProvider extends ChangeNotifier {
  // Recorder Provider runs at top of the app route,
  // Managing every recordings bind to navbar

  BuildContext context;

  // cachedPath manages remix videos scrolled by the user
  final Future<String> cachedPath = getOrCreateFolder('videos/user_generated');
  // uploadedPath manages videos (mostly mp4s) that are uploaded and being converted to scrolls
  // possible alternative to manual getOrCreateFolder is to set videos to choose from a local gallery
  final Future<String> uploadedPath = getOrCreateFolder(
      'videos/uploaded'); // = getGalleryFolder(); -> in case of choosing from local gallery
  // Converter should be managed by its parent
  Converter? converter;
  // Recorder
  Recorder _recorder = Recorder();
  IndexTimeLine? _recordedTimeLine;

  // Recording Indicator
  bool isRecording = false;

  // True if meets the specific condition
  bool isUploadable = false;

  ScrollsModel? currentScrolls;

  void startRecording() {
    _recorder.startRecording();
    isRecording = true;
  }

  void stopRecording() {
    _recordedTimeLine = _recorder.stopRecording();
    //popUp();
    IndexTimeLine? userGeneratedTimeLine = getTimeLine();

    if (userGeneratedTimeLine != null &&
        userGeneratedTimeLine.last! - userGeneratedTimeLine.first! >
            const Duration(milliseconds: 200)) {
      // convert into remix
      RemixModel remix = RemixModel(
        'new',
        scrolls: currentScrolls!,
        timeline: userGeneratedTimeLine,
      );

      saveRemix(remix);
    }
    isRecording = false;
  }

  void popUp() {
    // Shows pop up for inputs for new video generated
    showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        barrierColor: Colors.black54,
        topRadius: const Radius.circular(20),
        backgroundColor: mainBackgroundColor,
        builder: (context) => Container(
              height: 700,
              width: double.infinity,
            ));
  }

  IndexTimeLine? getTimeLine() {
    // bombs _recordedTimeLine after calling... resets
    IndexTimeLine? timeLine = _recordedTimeLine;
    _recordedTimeLine = null;
    return timeLine;
  }

  bool updateRecording(int index, ScrollsModel scrollsModel) {
    currentScrolls = scrollsModel;
    return _recorder.updateRecording(index);
  }

  // All of the bellow are replicate to the RecordedVideoManager... Needs merging...

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

  RecorderProvider({this.converter, required this.context}) {
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
