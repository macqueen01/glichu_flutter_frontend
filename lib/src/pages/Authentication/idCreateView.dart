import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/mainPage.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/signUpView.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:provider/provider.dart';

Scaffold IdCreateView(BuildContext context) {
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
              'ONE AND',
              style: GoogleFonts.quicksand(
                  color: mainBackgroundColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "ONLY ",
                        style: GoogleFonts.quicksand(
                            color: mainBackgroundColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1)),
                    TextSpan(
                        text: "NAME",
                        style: GoogleFonts.quicksand(
                            color: mainBackgroundColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1))
                  ]),
                ))
          ],
        ),
      ),
      title: const Text(
        'Setup your name',
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
            fontWeight: FontWeight.w200,
            color: mainBackgroundColor,
            textBaseline: TextBaseline.alphabetic),
      ),
      onForwardButtonPressed: (BuildContext context) {},
      onBackButtonPressed: (BuildContext context) {},
      backButtonActivate: false,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: AnimatedTextField(
                  placeholder: "Personal Id",
                  placeholderColor: Colors.white70,
                  placeholderColorFocused: Colors.white,
                  borderColor: Colors.white,
                  mainTextColor: mainSubThemeColor,
                  callBack:
                      context.read<AuthenticationCenterProvider>().setMJId,
                  width: 300,
                  hidden: true),
            ),
            BoxContainer(
              context: context,
              width: 330,
              height: 80,
              radius: 10,
              backgroundColor: Colors.transparent,
              child: FutureBuilder<Widget>(
                  future: UserIdCheckInfoBox(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return Container();
                    }
                  }),
            ),
          ]),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
          alignment: Alignment.topCenter,
          child: Container(
            height: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () async {
                    if (!await context
                        .read<AuthenticationCenterProvider>()
                        .isValidId()) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(redSnackbar(
                          context, "This user id cannot be accepted"));
                      return;
                    }
                    context.read<AuthenticationCenterProvider>().resetIndex(3);
                  },
                  width: 300,
                  height: 45,
                  radius: 10,
                  gradient: minimizedLensFlareGradient,
                  content: Text("Join",
                      style: GoogleFonts.quicksand(
                          letterSpacing: 0.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mainBackgroundColor)),
                ),
                FlatButton(
                    onPressed: () {
                      context.read<AuthenticationCenterProvider>().resetAll();
                    },
                    width: 300,
                    height: 45,
                    radius: 10,
                    color: Color.fromARGB(255, 85, 85, 85),
                    content: Text("Cancel",
                        style: GoogleFonts.quicksand(
                            letterSpacing: 0.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: mainBackgroundColor)))
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Future<Widget> UserIdCheckInfoBox(BuildContext context) async {
  AuthenticationCenterProvider provider =
      context.read<AuthenticationCenterProvider>();

  bool inUse = await provider.isIdAlreadyInUse();

  List<bool> conditions = [
    provider.isEmptyId(),
    provider.isNotValidStringId(),
    await provider.isIdAlreadyInUse()
  ];

  List<String> messages = [
    "Check you have entered your ID",
    "ID must not contain any white space, #, -, or @",
    "ID is already in use"
  ];

  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < conditions.length; i++)
          if (conditions[i])
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                messages[i],
                style: TextStyle(
                    color: Color.fromARGB(255, 229, 65, 53),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
              ),
            ),
      ],
    ),
  );
}
