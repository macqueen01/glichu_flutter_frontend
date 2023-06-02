// This file stores any informations that are shared across the app.
// Settings are only acceessible of writing through writing this file.
// All informations should be immutable.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';

String mainUrl = 'https://storage.memehouses.com/scrolls';
String testUrl = 'http://localhost:8000/scrolls';

class BaseUrl {
  BaseUrlGenerator baseUrl = BaseUrlGenerator(mainUrl: testUrl);
}

class BaseUrlGenerator {
  late final String baseUrl;
  late final String scrollsUrl;
  late final String scrollsFetchUrl =
      'https://mockingjae-test-bucket.s3.ap-northeast-2.amazonaws.com/scrolls/';
  late final ScrollsUploadUrls scrollsUploadUrls;
  late final ScrollsBrowseUrls scrollsBrowseUrls;
  late final AutoRecordingUrls autoRecordingUrls;
  late final AuthenticationUrls authenticationUrls;
  late final ProfileUrls profileUrls;
  late final MessagingUrls messagingUrls;
  late final SocialInteractionUrls socialInteractionUrls;

  BaseUrlGenerator({required mainUrl}) {
    baseUrl = mainUrl;
    scrollsUrl = mainUrl;
    scrollsUploadUrls = ScrollsUploadUrls(mainUrl: mainUrl);
    scrollsBrowseUrls = ScrollsBrowseUrls(mainUrl: mainUrl);
    autoRecordingUrls = AutoRecordingUrls(mainUrl: mainUrl);
    authenticationUrls = AuthenticationUrls(mainUrl: mainUrl);
    profileUrls = ProfileUrls(mainUrl: mainUrl);
    messagingUrls = MessagingUrls(mainUrl: mainUrl);
    socialInteractionUrls = SocialInteractionUrls(mainUrl: mainUrl);
  }
}

class ScrollsBrowseUrls {
  late final String baseUrl;

  ScrollsBrowseUrls({required mainUrl}) {
    baseUrl = '$mainUrl/browse';
  }
}

class AutoRecordingUrls {
  late final String baseUrl;
  late final remixUploadUrl;
  late final remixBrowseUrl;

  AutoRecordingUrls({required mainUrl}) {
    baseUrl = '$mainUrl/auto-recording';
    remixUploadUrl = '$baseUrl/upload';
    remixBrowseUrl = '$baseUrl/browse';
  }
}

class ScrollsUploadUrls {
  late final String baseUrl;
  late final String videoUpload;
  late final String scrollify;
  late final String scrollsUpload;
  late final String getTaskStatus;

  ScrollsUploadUrls({required mainUrl}) {
    baseUrl = '$mainUrl/upload';
    videoUpload = '$baseUrl/video';
    scrollify = '$baseUrl/scrollify';
    scrollsUpload = '$baseUrl/post';
    getTaskStatus = '$baseUrl/task';
  }
}

class AuthenticationUrls {
  late final String baseUrl;
  late final String doesUserExist;
  late final String loginUser;
  late final String createUser;
  late final String logoutUser;
  late final String MJLoginUser;

  AuthenticationUrls({required mainUrl}) {
    baseUrl = '$mainUrl/auth';
    doesUserExist = '$baseUrl/user-exists';
    loginUser = '$baseUrl/login';
    createUser = '$baseUrl/join';
    logoutUser = '$baseUrl/logout';
    MJLoginUser = '$baseUrl/login/token';
  }
}

class ProfileUrls {
  late final String baseUrl;
  late final String followingsUrl;
  late final String followersUrl;
  late final String selfUrl;
  late final String isSelfUrl;

  ProfileUrls({required mainUrl}) {
    baseUrl = '$mainUrl/user';
    followingsUrl = '$baseUrl/following';
    followersUrl = '$baseUrl/follower';
    selfUrl = '$baseUrl/self';
    isSelfUrl = '$baseUrl/is-self';
  }
}

class MessagingUrls {
  late final String baseUrl;
  late final String autoRecordingMessageUpload;
  late final String autoRecordingMessage;

  MessagingUrls({required mainUrl}) {
    baseUrl = '$mainUrl/messaging';
    autoRecordingMessageUpload = '$baseUrl/auto-recording/upload';
    autoRecordingMessage = '$baseUrl/auto-recording';
  }
}

class SocialInteractionUrls {
  late final String baseUrl;
  late final String likeUrl;
  late final String followUrl;
  late final String unfollowUrl;

  SocialInteractionUrls({required mainUrl}) {
    baseUrl = '$mainUrl/user';
    likeUrl = '$baseUrl/like';
    followUrl = '$baseUrl/follow';
    unfollowUrl = '$baseUrl/unfollow';
  }
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
