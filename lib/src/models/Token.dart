import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

Future<Token> getToken(String appId, String appSecret) async {
  dio.Dio dioClient = dio.Dio();
  Stream<String> onCode = await _server();

  String url =
      "https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=http://127.0.0.1:8585/&scope=user_profile,user_media&response_type=code";

  final String code = await onCode.first;

  final dio.Response response = await dioClient
      .post("https://api.instagram.com/oauth/access_token", data: {
    "client_id": appId,
    "redirect_uri": "http://127.0.0.1:8585/",
    "client_secret": appSecret,
    "code": code,
    "grant_type": "authorization_code"
  });

  return Token.fromMap(response.data);
}

Future<Stream<String>> _server() async {
  final StreamController<String> onCode = StreamController();
  io.HttpServer server = await io.HttpServer.bind("127.0.0.1", 8585);
  server.listen((io.HttpRequest request) async {
    final String code = request.uri.queryParameters["code"]!;
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", io.ContentType.html.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}

class Token {
  late String access;
  late String id;

  Token({required this.access, required this.id});

  Token.fromMap(Map json) {
    access = json['access_token'];
    id = json['user-id'];
  }
}
