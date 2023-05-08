import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
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
  }
}

class AuthenticationViewChanger extends StatelessWidget {
  const AuthenticationViewChanger({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationCenterProvider>(
      builder: (context, provider, child) {
        if (provider.index == 0) {
          return MainView(context);
        } else if (provider.index == 1) {
          return JoinView(context);
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
      preferredSize: const Size.fromHeight(190),
      backgroundColor: Colors.transparent,
      headerTextWidget: Column(
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
              margin: EdgeInsets.only(top: 17, bottom: 10),
              child: LogoNavIcon(100, 55, mainBackgroundColor))
        ],
      ),
      title: const Text(
        'Registration',
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
                  onPressed: () {
                    context.read<AuthenticationCenterProvider>().resetIndex(1);
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
}

class AuthenticationCenterProvider extends ChangeNotifier {
  // manages all data needed during authentication process

  BuildContext context;

  int index = 0;

  void resetIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  int getIndex() {
    print(index);
    return index;
  }

  AuthenticationCenterProvider({required this.context});
}
