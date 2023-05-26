import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/api/authentication.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:tar/tar.dart';
import 'package:dio/dio.dart' as dio;

import 'package:mockingjae2_mobile/src/settings.dart';

class AutoRecorderApi {
  BaseUrlGenerator backendUrls = BaseUrl().baseUrl;
  AuthenticationHeader header = AuthenticationHeader();
  dio.Dio dioClient = dio.Dio();

  Future<void> uploadRemix(
      RemixModel autoRecordingRemixModel, String token) async {
    try {
      dio.Response response = await dioClient.post(
          backendUrls.autoRecordingUrls.remixUploadUrl,
          data: autoRecordingRemixModel.toJsonWithToken(token),
          options: dio.Options(headers: await header.getHeader()));
    } catch (e) {
      print(e);
    }
  }

  Future<List<RemixViewModel>> fetchRemixFromScrollsId(int scrollsId) async {
    try {
      dio.Response response = await dioClient.get(
          '${backendUrls.autoRecordingUrls.remixBrowseUrl}?id=$scrollsId&mp4=False',
          options: dio.Options(headers: await header.getHeader()));

      List<RemixViewModel> remixList = [];
      for (var remix in response.data['results']) {
        remixList.add(RemixViewModel.fromMap(remix));
      }
      return remixList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<RemixViewModel>> fetchRemixFromScrollsIdByRecent(
      int scrollsId, int page) async {
    try {
      dio.Response response = await dioClient.get(
          '${backendUrls.autoRecordingUrls.remixBrowseUrl}?id=$scrollsId&recent=true&mp4=False&page=$page',
          options: dio.Options(headers: await header.getHeader()));

      List<RemixViewModel> remixList = [];
      for (var remix in response.data['results']) {
        remixList.add(RemixViewModel.fromMap(remix));
      }
      return remixList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<RemixViewModel>> fetchRemixFromScrollsIdByMostScrolled(
      int scrollsId, int page) async {
    try {
      dio.Response response = await dioClient.get(
          '${backendUrls.autoRecordingUrls.remixBrowseUrl}?id=$scrollsId&most-scrolled=true&mp4=False&page=$page',
          options: dio.Options(headers: await header.getHeader()));

      List<RemixViewModel> remixList = [];
      for (var remix in response.data['results']) {
        remixList.add(RemixViewModel.fromMap(remix));
      }
      return remixList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<RemixViewModel>> fetchRemixFromScrollsIdByFollowers(
      int scrollsId, int page) async {
    try {
      dio.Response response = await dioClient.get(
          '${backendUrls.autoRecordingUrls.remixBrowseUrl}?id=$scrollsId&followers=true&mp4=False&page=$page',
          options: dio.Options(headers: await header.getHeader()));

      List<RemixViewModel> remixList = [];
      for (var remix in response.data['results']) {
        remixList.add(RemixViewModel.fromMap(remix));
      }
      return remixList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
