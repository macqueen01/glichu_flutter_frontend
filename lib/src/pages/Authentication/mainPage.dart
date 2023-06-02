import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/Providers/authenticationPageProvider.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/idCreateView.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/loginLandingView.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/profilePictureSelect.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/signUpView.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

import 'package:provider/provider.dart';

class AuthenticationCenterPage extends StatefulWidget {
  const AuthenticationCenterPage({super.key});

  static const routeName = '/authenticationCenter';

  @override
  State<AuthenticationCenterPage> createState() =>
      _AuthenticationCenterPageState();
}

class _AuthenticationCenterPageState extends State<AuthenticationCenterPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AuthenticationCenterProvider(context: context))
      ],
      child: AuthenticationViewChanger(),
    );

    // return JoinView(context);
  }
}

class AuthenticationViewChanger extends StatelessWidget {
  const AuthenticationViewChanger({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationCenterProvider>(
      builder: (context, provider, child) {
        if (provider.index == 0) {
          return JoinView();
        } else if (provider.index == 1) {
          return MainView(context);
        } else if (provider.index == 2) {
          return IdCreateView(context);
        } else if (provider.index == 3) {
          return ProfileCreateView(context);
        } else if (provider.index == 4) {
          if (!provider.has_error) {
            provider.sendJoinRequest(() {
              Navigator.pop(context);
            });
          }
          return LoginLandingView(context);
        }
        return MainView(context);
      },
    );
  }
}

Scaffold MainView(BuildContext context) {
  return Scaffold(
    backgroundColor: scrollsBackgroundColor,
    resizeToAvoidBottomInset: true,
    extendBody: true,
    appBar: BigAppBar(
      preferredSize: const Size.fromHeight(200),
      backgroundColor: Colors.transparent,
      headerTextWidget: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'ADD',
              style: GoogleFonts.quicksand(
                  color: mainBackgroundColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1),
            ),
            Container(
                child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "ME ",
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                TextSpan(
                    text: "IN",
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1))
              ]),
            ))
          ],
        ),
      ),
      title: const Text(
        'Registration',
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
            fontWeight: FontWeight.w200,
            color: mainBackgroundColor,
            textBaseline: TextBaseline.alphabetic),
      ),
      onForwardButtonPressed: (BuildContext context) {},
      onBackButtonPressed: (context) {
        context.read<AuthenticationCenterProvider>().resetIndex(0);
      },
      forwardButtonActivate: false,
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
                              child: Text(
                                "If you're already signed in,",
                                style: TextStyle(
                                    color: mainBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            FlatButton(
                                onPressed: () {
                                  context
                                      .read<AuthenticationCenterProvider>()
                                      .sendLoginRequest(
                                    () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                gradient: minimizedLensFlareGradient,
                                icon: SvgPicture.asset(
                                  'assets/icons/locked.svg',
                                  width: 18,
                                  height: 18,
                                  color: mainBackgroundColor,
                                ),
                                content: Text("Login",
                                    style: GoogleFonts.quicksand(
                                        letterSpacing: 0.5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: mainBackgroundColor)),
                                width: 300,
                                height: 40,
                                radius: 10),
                          ],
                        ),
                      ),
                      Container(
                        height: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "or, if you're new here ...",
                                style: TextStyle(
                                    color: mainBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            FlatButton(
                                onPressed: () {
                                  context
                                      .read<AuthenticationCenterProvider>()
                                      .resetIndex(2);
                                },
                                gradient: minimizedWarmGradient,
                                icon: SvgPicture.asset(
                                  'assets/icons/draw.svg',
                                  width: 18,
                                  height: 18,
                                  color: mainBackgroundColor,
                                ),
                                content: Text("Join",
                                    style: GoogleFonts.quicksand(
                                        letterSpacing: 0.5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: mainBackgroundColor)),
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
