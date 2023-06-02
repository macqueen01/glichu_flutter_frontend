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

class RelationsFetcher {
  BaseUrlGenerator backendUrls = BaseUrl().baseUrl;
  AuthenticationHeader header = AuthenticationHeader();

  Future<UserMin?> fetchUserSelf() async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return null;
    }

    final userUrl = Uri.parse('${backendUrls.profileUrls.selfUrl}');
    final response = await get(userUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      final userMap = json.decode(response.body);
      final UserMin user = UserMin.fromJson(userMap);

      return user;
    } else {
      return null;
    }
  }

  Future<UserMin?> fetchUserMin(String userId) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return null;
    }

    final userUrl = Uri.parse('${backendUrls.profileUrls.baseUrl}?id=$userId');
    final response = await get(userUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      final userMap = json.decode(response.body);
      final UserMin user = UserMin.fromJson(userMap);

      return user;
    } else {
      return null;
    }
  }

  Future<List<UserMin>> fetchFollowersOfUser(
      String userId, int page, Function? callback) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return [];
    }

    final followersUrl = Uri.parse(
        '${backendUrls.profileUrls.followersUrl}?id=$userId&page=$page');
    final response = await get(followersUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> usersMap = json.decode(response.body)['results'];
      final List<UserMin> users = [];

      usersMap.forEach((user) {
        users.add(UserMin.fromJson(user));
      });

      callback!();

      return users;
    } else {
      return [];
    }
  }

  Future<List<UserMin>> fetchFollowingsOfUser(
      String userId, int page, Function? callback) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return [];
    }

    final followingsUrl = Uri.parse(
        '${backendUrls.profileUrls.followingsUrl}?id=$userId&page=$page');
    final response = await get(followingsUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> usersMap = json.decode(response.body)['results'];
      final List<UserMin> users = [];

      usersMap.forEach((user) {
        users.add(UserMin.fromJson(user));
      });

      callback!();

      return users;
    } else {
      return [];
    }
  }

  Future<bool> isSelfQuery(int targetId) async {
    Map<String, String>? headerMap = await header.getHeader();

    if (headerMap == null) {
      return false;
    }

    final isSelfUrl =
        Uri.parse('${backendUrls.profileUrls.isSelfUrl}?id=$targetId');
    final response = await get(isSelfUrl, headers: headerMap);

    if (response.statusCode == HttpStatus.ok) {
      final int result = json.decode(response.body)['is_self'];
      bool isSelf = result == 1 ? true : false;

      return isSelf;
    } else {
      return false;
    }
  }
}
