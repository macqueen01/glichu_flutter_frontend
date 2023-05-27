import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/AutoRecordingPlayer/autoRecordingMessage.dart';
import 'package:mockingjae2_mobile/src/api/authentication.dart';
import 'package:mockingjae2_mobile/src/api/utility.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/settings.dart';
import 'package:dio/dio.dart' as dio;

class MessageApi {
  BaseUrlGenerator backendUrls = BaseUrl().baseUrl;
  AuthenticationHeader header = AuthenticationHeader();

  dio.Dio dioClient = dio.Dio();

  Future<void> pushAutoRecordingMessage(AutoRecordingMessage message) async {
    Map? response = await _pushAutoRecordingMessage(
        message.remixId,
        int.parse(message.commenter.userId),
        int.parse(message.commentee.userId),
        message.message);

    if (isValidResponse(response!, ['message_id'])) {
      print(response['message_id']);
    }
  }

  Future<Map?> _pushAutoRecordingMessage(
      int remixId, int userId, int targetId, String message) async {
    dio.FormData formData = dio.FormData.fromMap({
      'origin': userId,
      'target': targetId,
      'remix_id': remixId,
      'message': message
    });

    try {
      dio.Response response = await dioClient.post(
          backendUrls.messagingUrls.autoRecordingMessageUpload,
          data: formData,
          options: dio.Options(headers: await header.getHeader()));

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
