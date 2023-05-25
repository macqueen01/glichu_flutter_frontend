import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/models/Token.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/loginLandingView.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/mainPage.dart';
import 'package:mockingjae2_mobile/src/secret.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modals/modals.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart' as web;
import 'package:webview_flutter/webview_flutter.dart';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class JoinView extends StatefulWidget {
  const JoinView({super.key});

  @override
  State<JoinView> createState() => _JoinViewState();
}

class _JoinViewState extends State<JoinView> {
  bool _pending = true;

  @override
  Widget build(BuildContext context) {
    AuthenticationCenterProvider provider =
        context.read<AuthenticationCenterProvider>();

    if (_pending) {
      Timer(const Duration(milliseconds: 500), () {
        provider.sendMJLoginRequestAsync().then((value) {
          if (value != null) {
            provider.setUserMin(value);
          }
          setState(() {
            _pending = false;
          });
        });
      });
    }

    if (provider.userMin != null) {
      Navigator.pop(context);
    }

    if (_pending) {
      return LoginLandingView(context);
    }

    return Scaffold(
      backgroundColor: scrollsBackgroundColor,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: BigAppBar(
        onBackButtonPressed: (BuildContext context) {},
        onForwardButtonPressed: (BuildContext context) {},
        backButtonActivate: false,
        preferredSize: const Size.fromHeight(200),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        headerTextWidget: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: GoogleFonts.quicksand(
                    color: mainBackgroundColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              Container(
                  margin: EdgeInsets.only(top: 17),
                  child: LogoNavIcon(100, 55, mainBackgroundColor))
            ],
          ),
        ),
        title: const Text(
          '',
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.w200,
              color: mainBackgroundColor,
              textBaseline: TextBaseline.alphabetic),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Now start with ...",
                                  style: TextStyle(
                                      color: mainBackgroundColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              FlatButton(
                                  onPressed: () async {
                                    AuthenticationCenterProvider provider =
                                        context.read<
                                            AuthenticationCenterProvider>();

                                    try {
                                      final credential = await SignInWithApple
                                          .getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );

                                      provider
                                          .setAppleCredentialInfo(credential);

                                      //provider.setAppleCredentialInfo(credential);
                                    } catch (e) {
                                      provider.resetAll();
                                      print(e);
                                    }
                                  },
                                  color: Colors.white,
                                  icon: SvgPicture.asset(
                                      'assets/icons/apple.svg',
                                      width: 18,
                                      height: 18,
                                      color: Colors.black),
                                  content: Text("Apple",
                                      style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  width: 300,
                                  height: 40,
                                  radius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.only(bottom: 55),
              alignment: Alignment.center,
              child: Text(
                "from Jinhae",
                style: GoogleFonts.quicksand(
                  color: mainBackgroundColor,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WebView extends StatefulWidget {
  WebView({super.key, required this.provider});

  AuthenticationCenterProvider provider;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool verified = false;

  int? user_id;
  String? access_token;

  late web.NavigationDelegate delegate = web.NavigationDelegate(
      onNavigationRequest: (request) => webDecision(request));

  web.NavigationDecision webDecision(web.NavigationRequest request) {
    // This can intercept any navigation within the WebView.
    if (request.url.startsWith(redirectUrl)) {
      final startIndex = request.url.indexOf('code=');
      final endIndex = request.url.lastIndexOf('#');
      final code = request.url.substring(startIndex + 5, endIndex);
      login(code);
      return web.NavigationDecision.prevent;
    }
    return web.NavigationDecision.navigate;
  }

  void login(code) async {
    dio.Dio dioClient = dio.Dio();

    http.Response response = await http
        .post(Uri.parse("https://api.instagram.com/oauth/access_token"), body: {
      "client_id": appId,
      "client_secret": appSecretCode,
      "grant_type": "authorization_code",
      "redirect_uri": "https://memehouses.com/scrolls",
      "code": "$code"
    });

    dynamic decodedBody = jsonDecode(response.body);
    setState(() {
      verified = true;
      user_id = decodedBody['user_id'];
      access_token = decodedBody['access_token'];
    });
  }

  late web.WebViewController controller = web.WebViewController()
    ..setJavaScriptMode(web.JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.white)
    ..setNavigationDelegate(delegate)
    ..loadRequest(Uri.parse(authUrl));

  @override
  Widget build(BuildContext context) {
    if (verified && user_id != null && access_token != null) {
      widget.provider.setUserIdAndAccessToken(user_id!, access_token!);
      Navigator.pop(context);
    }
    return WebViewWidget(controller: controller);
  }
}
