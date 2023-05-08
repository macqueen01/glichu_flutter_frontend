// This file stores any informations that are shared across the app.
// Settings are only acceessible of writing through writing this file.
// All informations should be immutable.

import 'dart:math';

class BaseUrl {
  final String baseUrl = 'https://storage.memehouses.com';
  final String scrollsUrl = 'https://storage.memehouses.com/scrolls';
  final String scrollsFetchUrl =
      'https://scrollsbucket01.s3.ap-northeast-2.amazonaws.com/scrolls/';
  final ScrollsUploadUrls scrollsUploadUrls = ScrollsUploadUrls();
  final ScrollsBrowseUrls scrollsBrowseUrls = ScrollsBrowseUrls();
  final AutoRecordingUrls autoRecordingUrls = AutoRecordingUrls();
}

class ScrollsBrowseUrls {
  final String baseUrl = 'https://storage.memehouses.com/scrolls/browse';
  final String testUrl = 'http://0.0.0.0:8000/scrolls/browse';
}

class AutoRecordingUrls {
  final String baseUrl =
      'https://storage.memehouses.com/scrolls/auto-recording';
  final String testUrl = 'http://';
  late final remixUploadUrl = '$baseUrl/upload';
}

class ScrollsUploadUrls {
  final String baseUrl = 'https://storage.memehouses.com/scrolls/upload';
  late final String videoUpload = '$baseUrl/video';
  late final String scrollify = '$baseUrl/scrollify';
  late final String scrollsUpload = '$baseUrl/post';
  late final String getTaskStatus = '$baseUrl/task';
}

// Below should only be used under debugging flag

class SampleScrolls {
  final List<String> sampleScrolls = [
    '1_sample_scrolls2',
    '16_Poop_squr',
    '19_Reverse_Spill',
    '18_Tokatoka_pig',
    '17_Comic_fuck',
    '21_Infinite_Zoom',
    '22_Reversed_Boat_Ride'
  ];

  String getSampleScrolls() {
    // pick random choices in sampleScrolls and return the string value
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final index = random.nextInt(sampleScrolls.length);
    return sampleScrolls[index];
  }
}
