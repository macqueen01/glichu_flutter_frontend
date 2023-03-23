// This file stores any informations that are shared across the app.
// Settings are only acceessible of writing through writing this file.
// All informations should be immutable.

import 'package:http/http.dart';

class BaseUrl {
  final String baseUrl = 'https://storage.memehouses.com';
  final String scrollsUrl = 'https://storage.memehouses.com/scrolls';
  final String scrollsBrowseUrl =
      'https://storage.memehouses.com/scrolls/browse';
}
