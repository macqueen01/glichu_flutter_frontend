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
  Directory? imagePath;
  late Uri scrollsUrl;
  late String scrollsName;
  late bool isRestricted;
  late List<int> highlightIndexList;

  ScrollsModel(
      {required this.scrollsName,
      required this.highlightIndexList,
      this.isRestricted = false});

  ScrollsModel.fromMap(Map<String, dynamic> map) {
    scrollsName = map[
        'scrollsName']; // scrollsName is combination of original id + name (ex. '1_text')
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
      Directory('${scrollsDirectory.path}/audio/${index}_forward_.mp3');

  Directory get backward =>
      Directory('${scrollsDirectory.path}/audio/${index}_backward_.mp3');

  AudioDirectory indexedAt(int index) {
    return AudioDirectory(scrollsDirectory, index: index);
  }
}

// Utility methods for ScrollsModel

int getScrollsId(String scrollsName) {
  return int.parse(scrollsName.split('_').first);
}

String getScrollsName(String scrollsName) {
  // returns the rest of the scrollsName without 'number_' in front
  return scrollsName.split('_').sublist(1).join('_');
}
