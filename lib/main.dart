import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/mainPage.dart';
import 'package:mockingjae2_mobile/src/pages/likes.dart';
import 'package:mockingjae2_mobile/src/pages/profile.dart';
import 'package:mockingjae2_mobile/src/pages/profileScrolls.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/app.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mockingjae2_mobile/src/pages/example.dart';

void main() {
  // This prevents landscape view
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Running App

  //runApp(const MyApp());
  runApp(const MockingJaeMain());
}

class MockingJaeMain extends StatelessWidget {
  const MockingJaeMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This sets default app view as Dark mode
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      initialRoute: '/authenticationCenter',
      // route with navigation arguments should be imported, and added to routes
      // this will break the dependancy policy... need to find a way to fix this
      routes: {
        '/authenticationCenter': (context) => const AuthenticationCenterPage(),
        '/': (context) => ChangeNotifierProvider(
            create: (context) => RecorderProvider(context: context),
            child: const MainPage()),
        '/profile': (context) => const ProfilePage(),
        LikesPage.routeName: (context) => const LikesPage(),
        ProfileScrollsPage.routeName: (context) => const ProfileScrollsPage(),
      },
      debugShowCheckedModeBanner: false,
      title: "mockingJae 2.0",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: mainBackgroundColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: mainThemeColor,
            elevation: 0,
            titleTextStyle: TextStyle(color: Colors.black)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: mainSubThemeColor),
      ),
    );
  }
}
