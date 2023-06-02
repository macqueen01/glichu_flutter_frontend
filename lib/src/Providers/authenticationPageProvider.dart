import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/api/authentication.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationCenterProvider extends ChangeNotifier {
  // manages all data needed during authentication process

  BuildContext context;

  int index = 0;
  int? user_id;
  String? access_token;
  // Only for apple login
  String? authorizationCode;
  String? userEmail;
  String? userIdentifier;

  String? MockingJaeId;
  AuthenticationAPI authenticationAPI = AuthenticationAPI();
  bool has_error = false;
  Future<File?> profileImage = Future.value(null);
  UserMin? userMin;
  bool MJloginPending = false;

  TokenDatabase database = TokenDatabase.instance;

  void resetIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  void resetImage(File newImage) {
    profileImage =
        Future.delayed(Duration(milliseconds: 20)).then((value) => newImage);
    notifyListeners();
  }

  int getIndex() {
    return index;
  }

  bool is_authenticated() {
    if (access_token != null) {
      return true;
    }
    return false;
  }

  Future<bool> isValidId() async {
    if (!is_authenticated() || isEmptyId()) {
      return false;
    }

    // check if user id contains any white space, #, -, or @
    if (!isNotValidStringId()) {
      return true;
    }

    // request to server to check if the MockingJaeId already exists
    if (!await isIdAlreadyInUse()) {
      return true;
    }

    return false;
  }

  bool isEmptyId() {
    if (MockingJaeId == null || MockingJaeId!.isEmpty) {
      return true;
    }
    return false;
  }

  bool isNotValidStringId() {
    if (MockingJaeId!.contains(' ') ||
        MockingJaeId!.contains('#') ||
        MockingJaeId!.contains('-') ||
        MockingJaeId!.contains('@')) {
      return true;
    }
    return false;
  }

  Future<bool> isIdAlreadyInUse() async {
    return await authenticationAPI.doesUserIdExists(MockingJaeId!);
  }

  void setUserId(int id) {
    user_id = id;
  }

  void setUserAuthorizationCodeAndEmail(String code, String Email) {
    access_token = code;
  }

  void setAccessToken(String token) {
    access_token = token;
    print(token);
  }

  void setUserIdAndAccessToken(int id, String token) {
    setUserId(id);
    setAccessToken(token);
    Timer(const Duration(milliseconds: 20), () {
      resetIndex(1);
    });
  }

  void setAppleCredentialInfo(AuthorizationCredentialAppleID credential) {
    authorizationCode = credential.authorizationCode;
    userEmail = credential.email != null ? credential.email : null;
    userIdentifier = credential.userIdentifier;
    setAccessToken(credential.identityToken!);
    Timer(const Duration(milliseconds: 20), () {
      resetIndex(1);
    });
  }

  void setMJId(String MockingJaeId) {
    this.MockingJaeId = MockingJaeId;
    notifyListeners();
  }

  void setUserMin(UserMin user) {
    userMin = user;
  }

  void setMJPending(bool status) {
    MJloginPending = status;
  }

  void sendJoinRequest(callback) {
    if (userIdentifier != null && authorizationCode != null) {
      authenticationAPI
          .joinWithApple(MockingJaeId!, userIdentifier!, userEmail,
              authorizationCode!, access_token!, profileImage)
          .then((value) {
        if (value != null) {
          database.saveToken(value);
          callback();
        } else {
          has_error = true;
          resetAll();
        }
      });
      return;
    }

    authenticationAPI
        .join(MockingJaeId!, user_id!, access_token!, profileImage)
        .then((value) {
      if (value != null) {
        database.saveToken(value);
        callback();
      } else {
        has_error = true;
        resetAll();
      }
    });
  }

  void resetAll() {
    user_id = null;
    access_token = null;
    MockingJaeId = null;
    has_error = false;
    index = 0;
    userEmail = null;
    userIdentifier = null;
    authorizationCode = null;
    profileImage = Future.value(null);
    notifyListeners();
  }

  void sendLoginRequest(callback) {
    if (userIdentifier != null && authorizationCode != null) {
      authenticationAPI
          .loginWithApple(userIdentifier!, authorizationCode!, access_token!)
          .then((value) {
        if (value != null) {
          database.saveToken(value);
          callback();
        } else {
          has_error = true;
          resetAll();
        }
      });
      return;
    }

    print('here');

    authenticationAPI.login(user_id!, access_token!).then((value) {
      if (value != null) {
        database.saveToken(value);
        callback();
      } else {
        has_error = true;
        resetAll();
      }
    });
  }

  Future<UserMin?> sendMJLoginRequestAsync() async {
    // This sends mocking Jae provided token to check login status
    // and login to the service

    String? token = await database.getToken();

    if (token == null) {
      return null;
    }

    UserMin? userMin = await authenticationAPI.MJlogin(token);

    if (userMin == null) {
      return null;
    }

    return userMin;
  }

  AuthenticationCenterProvider({required this.context});
}
