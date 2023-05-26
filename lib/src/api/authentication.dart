import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/settings.dart';
import 'package:dio/dio.dart' as dio;

class AuthenticationHeader {
  TokenDatabase database = TokenDatabase.instance;

  Future<Map<String, String>?> getHeader() async {
    String? token = await database.getToken();

    if (token == null) {
      return null;
    }

    return {'Authorization': 'Bearer $token'};
  }
}

class AuthenticationAPI {
  BaseUrlGenerator backendUrls = BaseUrl().baseUrl;
  dio.Dio dioClient = dio.Dio();
  AuthenticationHeader header = AuthenticationHeader();

  Future<Map?> _userIdCheckAPI(String MockingJaeId) async {
    dio.FormData formData = dio.FormData.fromMap({
      'username': MockingJaeId,
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient.post(
        backendUrls.authenticationUrls.doesUserExist,
        data: formData,
      );
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> doesUserIdExists(String MockingJaeId) async {
    Map? response = await _userIdCheckAPI(MockingJaeId);

    if (response == null) {
      return false;
    }

    if (response['exists'] == 0) {
      return false;
    }

    return true;
  }

  Future<Map?> _createInstagramUserAPI(String MockingJaeId, int user_id,
      String access_token, Future<File?> profileImage) async {
    File? profileImageFile = await profileImage;

    int nowHash = DateTime.now().toString().hashCode;

    dio.FormData formData = dio.FormData.fromMap({
      'username': MockingJaeId,
      'user_id': user_id,
      'access_token': access_token,
      'social_login_type': 'instagram',
      'profile_image': (profileImageFile == null)
          ? null
          : await dio.MultipartFile.fromFile(profileImageFile.path,
              filename: '${MockingJaeId}_$nowHash.jpg')
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.authenticationUrls.createUser, data: formData);
      return response.data;
    } catch (e) {
      if (e is dio.DioError) {
        return null;
      }
    }
  }

  Future _createAppleUserAPI(
      String MockingJaeId,
      String userIdentifier,
      String? userEmail,
      String authorizationCode,
      String access_token,
      Future<File?> profileImage) async {
    File? profileImageFile = await profileImage;
    int nowHash = DateTime.now().toString().hashCode;

    dio.FormData formData = dio.FormData.fromMap({
      'username': MockingJaeId,
      'user_identifier': userIdentifier,
      'user_email': userEmail != null ? userEmail : null,
      'authorization_code': authorizationCode,
      'access_token': access_token,
      'social_login_type': 'apple',
      'profile_image': (profileImageFile == null)
          ? null
          : await dio.MultipartFile.fromFile(profileImageFile.path,
              filename: '${MockingJaeId}_$nowHash.jpg')
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.authenticationUrls.createUser, data: formData);
      return response.data;
    } catch (e) {
      if (e is dio.DioError) {
        return null;
      }
    }
  }

  Future<Map?> _loginInstagramUserAPI(int user_id, String access_token) async {
    dio.FormData formData = dio.FormData.fromMap({
      'user_id': user_id,
      'access_token': access_token,
      'social_login_type': 'instagram',
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.authenticationUrls.loginUser, data: formData);
      return response.data;
    } catch (e) {
      if (e is dio.DioError) {
        return null;
      }
    }
  }

  Future<Map?> _loginAppleUserAPI(String userIdentifier,
      String authorizationCode, String access_token) async {
    dio.FormData formData = dio.FormData.fromMap({
      'user_identifier': userIdentifier,
      'access_token': access_token,
      'social_login_type': 'apple',
      'authorization_code': authorizationCode,
    });

    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.authenticationUrls.loginUser, data: formData);
      return response.data;
    } catch (e) {
      if (e is dio.DioError) {
        return null;
      }
    }
  }

  Future<Map?> _loginMJUserAPI(String mockingJaeToken) async {
    dio.FormData formData = dio.FormData.fromMap({'token': mockingJaeToken});
    print(mockingJaeToken);
    // Make the HTTP request
    try {
      dio.Response response = await dioClient
          .post(backendUrls.authenticationUrls.MJLoginUser, data: formData);
      return response.data;
    } catch (e) {
      if (e is dio.DioError) {
        return null;
      }
    }
  }

  Future<String?> join(String MockingJaeId, int user_id, String access_token,
      Future<File?> profile_image) async {
    Map? response = await _createInstagramUserAPI(
        MockingJaeId, user_id, access_token, profile_image);

    if (response != null) {
      return response['token'];
    }

    return null;
  }

  Future<String?> joinWithApple(
      String MockingJaeId,
      String userIdentifier,
      String? userEmail,
      String authorizationCode,
      String access_token,
      Future<File?> profile_image) async {
    Map? response = await _createAppleUserAPI(MockingJaeId, userIdentifier,
        userEmail, authorizationCode, access_token, profile_image);

    if (response != null) {
      return response['token'];
    }

    return null;
  }

  Future<String?> login(
    int user_id,
    String access_token,
  ) async {
    Map? response = await _loginInstagramUserAPI(user_id, access_token);

    if (response != null) {
      return response['token'];
    }

    return null;
  }

  Future<String?> loginWithApple(
    String userIdentifier,
    String authorizationCode,
    String access_token,
  ) async {
    Map? response = await _loginAppleUserAPI(
        userIdentifier, authorizationCode, access_token);

    if (response != null) {
      return response['token'];
    }

    return null;
  }

  Future<UserMin?> MJlogin(String mockingJaeToken) async {
    Map? response = await _loginMJUserAPI(mockingJaeToken);

    if (response != null && response.containsKey('username')) {
      return UserMin.fromJson(response);
    }

    return null;
  }
}
