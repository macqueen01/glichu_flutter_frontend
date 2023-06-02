import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/Providers/authenticationPageProvider.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:provider/provider.dart';

Scaffold LoginLandingView(BuildContext context) {
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
      backButtonActivate: false,
      forwardButtonActivate: false,
      onForwardButtonPressed: (BuildContext context) {},
      onBackButtonPressed: (BuildContext context) {},
    ),
    body: Padding(
      padding: const EdgeInsets.only(bottom: 190),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: context.read<AuthenticationCenterProvider>().has_error
            ? Container(
                width: 300,
                height: 180,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 30,
                      child: Text(
                        "Are you already with us ...?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            color: mainBackgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FlatButton(
                          onPressed: () async {
                            context
                                .read<AuthenticationCenterProvider>()
                                .resetAll();
                          },
                          color: mainBackgroundColor,
                          content: Text("Go back",
                              style: GoogleFonts.quicksand(
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: scrollsBackgroundColor)),
                          width: 140,
                          height: 40,
                          radius: 10),
                    ),
                  ],
                ),
              )
            : const CupertinoActivityIndicator(
                color: mainSubThemeColor, radius: 10.0, animating: true),
      ),
    ),
  );
}
