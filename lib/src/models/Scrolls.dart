import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';

/*

class Scrolls {
  const Scrolls({
    required String url,
    required String thumbnail,
    required 
  })
}
*/

class ScrollsModel {
  late Directory imagePath;
  late Uri scrollsUrl;
  late String scrollsName;
  late bool isRestricted;
  late List<int> highlightIndexList;

  ScrollsModel(
      {required this.imagePath,
      required this.scrollsName,
      required this.highlightIndexList,
      this.isRestricted = false});

  ScrollsModel.fromMap(Map<String, dynamic> map) {
    scrollsName = map['scrollsName'];
    highlightIndexList = map['highlightIndexList'];
    isRestricted = map['isRestricted'];
    scrollsUrl = map['url'];
  }
}

class Highlight {
  final int index;
  Uint8List? forwardAudioBuffer;
  Uint8List? reverseAudioBuffer;

  Highlight({
    required this.index,
    this.forwardAudioBuffer = null,
    this.reverseAudioBuffer = null,
  });

  // Audio Setting needs improvement
  Future<void> setAudio(Directory scrollsDirectory) async {
    Directory forwardAudioDir =
        AudioDirectory(scrollsDirectory).indexedAt(this.index).forward;
    Directory backwardAudioDir =
        AudioDirectory(scrollsDirectory).indexedAt(this.index).backward;
    this.forwardAudioBuffer = await fileRead(forwardAudioDir.path);
    this.reverseAudioBuffer = await fileRead(backwardAudioDir.path);
  }
}

class AudioDirectory {
  final Directory scrollsDirectory;
  final int index;

  AudioDirectory(this.scrollsDirectory, {this.index = 0});

  Directory get forward =>
      Directory(scrollsDirectory.path + '/audio/${index}_forward_.mp3');

  Directory get backward =>
      Directory(scrollsDirectory.path + '/audio/${index}_backward_.mp3');

  AudioDirectory indexedAt(int index) {
    return AudioDirectory(scrollsDirectory, index: index);
  }
}
