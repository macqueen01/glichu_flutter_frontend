import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/api/authentication.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:tar/tar.dart';
import 'package:dio/dio.dart' as dio;

import 'package:mockingjae2_mobile/src/settings.dart';

class SocialInteractionsAPI {
  BaseUrlGenerator backendUrls = BaseUrl().baseUrl;
  AuthenticationHeader header = AuthenticationHeader();

  Future<bool> followUser(String userId) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return false;
    }

    final followUrl =
        Uri.parse('${backendUrls.socialInteractionUrls.followUrl}?id=$userId');
    final response = await post(followUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfollowUser(String userId) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return false;
    }

    final unfollowUrl = Uri.parse(
        '${backendUrls.socialInteractionUrls.unfollowUrl}?id=$userId');
    final response = await post(unfollowUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }
}
