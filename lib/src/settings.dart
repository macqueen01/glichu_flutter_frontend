// This file stores any informations that are shared across the app.
// Settings are only acceessible of writing through writing this file.
// All informations should be immutable.

import 'dart:math';

String mainUrl = 'https://storage.memehouses.com/scrolls';
String testUrl = 'http://localhost:8000/scrolls';

class BaseUrl {
  final String baseUrl = mainUrl;
  final String scrollsUrl = mainUrl;
  final String scrollsFetchUrl =
      'https://mockingjae-test-bucket.s3.ap-northeast-2.amazonaws.com/scrolls/';
  final ScrollsUploadUrls scrollsUploadUrls = ScrollsUploadUrls();
  final ScrollsBrowseUrls scrollsBrowseUrls = ScrollsBrowseUrls();
  final AutoRecordingUrls autoRecordingUrls = AutoRecordingUrls();
  final AuthenticationUrls authenticationUrls = AuthenticationUrls();
  final ProfileUrls profileUrls = ProfileUrls();
}

class ScrollsBrowseUrls {
  final String baseUrl = '$mainUrl/browse';
  final String testUrl = 'http://localhost:8000/scrolls/browse';
}

class AutoRecordingUrls {
  final String baseUrl = '$mainUrl/auto-recording';
  final String testUrl = 'http://0.0.0.0:8000';
  late final remixUploadUrl = '$baseUrl/upload';
  late final remixBrowseUrl = '$baseUrl/browse';
}

class ScrollsUploadUrls {
  final String baseUrl = '$mainUrl/upload';
  late final String videoUpload = '$baseUrl/video';
  late final String scrollify = '$baseUrl/scrollify';
  late final String scrollsUpload = '$baseUrl/post';
  late final String getTaskStatus = '$baseUrl/task';
}

class AuthenticationUrls {
  final String baseUrl = '$mainUrl/auth';
  late final String doesUserExist = '$baseUrl/user-exists';
  late final String loginUser = '$baseUrl/login';
  late final String createUser = '$baseUrl/join';
  late final String logoutUser = '$baseUrl/logout';
  late final String MJLoginUser = '$baseUrl/login/token';
}

class ProfileUrls {
  final String baseUrl = '$mainUrl/scrolls/user';
  late final String followingsUrl = '$baseUrl/following';
  late final String followersUrl = '$baseUrl/follower';
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
