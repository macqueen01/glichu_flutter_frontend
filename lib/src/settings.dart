// This file stores any informations that are shared across the app.
// Settings are only acceessible of writing through writing this file.
// All informations should be immutable.

import 'dart:math';

class BaseUrl {
  final String baseUrl = 'https://storage.memehouses.com';
  final String scrollsUrl = 'https://storage.memehouses.com/scrolls';
  final String scrollsBrowseUrl =
      'https://scrollsbucket01.s3.ap-northeast-2.amazonaws.com/scrolls/';
}

// Below should only be used under debugging flag

class SampleScrolls {
  final List<String> sampleScrolls = ['1_sample_scrolls2', '16_Poop_squr'];

  String getSampleScrolls() {
    // pick random choices in sampleScrolls and return the string value
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final index = random.nextInt(sampleScrolls.length);
    return sampleScrolls[index];
  }
}
