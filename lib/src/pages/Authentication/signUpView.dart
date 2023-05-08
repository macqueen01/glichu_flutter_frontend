import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/mainPage.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:provider/provider.dart';

Scaffold Function(BuildContext context) JoinView = (BuildContext context) {
  return Scaffold(
    backgroundColor: scrollsBackgroundColor,
    resizeToAvoidBottomInset: true,
    extendBody: true,
    appBar: BigAppBar(
      onBackButtonPressed: (context) {
        context.read<AuthenticationCenterProvider>().resetIndex(0);
      },
      preferredSize: const Size.fromHeight(190),
      backgroundColor: Colors.transparent,
      headerTextWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADD',
            style: GoogleFonts.quicksand(
                color: mainBackgroundColor,
                fontSize: 44,
                fontWeight: FontWeight.w400,
                letterSpacing: 1),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 0),
            child: Text(
              'ME ON',
              style: GoogleFonts.quicksand(
                  color: mainBackgroundColor,
                  fontSize: 44,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1),
            ),
          )
        ],
      ),
      title: const Text(
        'Join',
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: mainBackgroundColor,
            textBaseline: TextBaseline.alphabetic),
      ),
      onForwardButtonPressed: (BuildContext context) {},
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
              FlatButton(
                  onPressed: () {},
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "or",
                  style: TextStyle(
                    color: mainBackgroundColor,
                    fontSize: 18,
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {},
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
};
