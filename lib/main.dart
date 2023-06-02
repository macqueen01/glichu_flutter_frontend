import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mockingjae2_mobile/src/pages/followers.dart';
import 'package:mockingjae2_mobile/src/pages/home.dart';
import 'package:mockingjae2_mobile/src/pages/idEditPage.dart';
import 'package:mockingjae2_mobile/src/pages/taggerEditPage.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
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

Future<void> main() async {
  // This prevents landscape view
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize the database
  final database = await TokenDatabase.instance.database;
  // Initialize the Nfc Manager
  final NfcManager nfcManager = NfcManager.instance;

  // Running App
  runApp(MockingJaeMain(
    database: database,
  ));
}

class MockingJaeMain extends StatelessWidget {
  final Database database;

  const MockingJaeMain({required this.database});

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
        SelfProfilePage.routeName: (context) => SelfProfilePage(),
        RelationsPage.routeName: (context) => const RelationsPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        LikesPage.routeName: (context) => const LikesPage(),
        ProfileScrollsPage.routeName: (context) => ChangeNotifierProvider(
            create: (context) => RecorderProvider(context: context),
            child: const ProfileScrollsPage()),
        NameEditPage.routeName: (context) => const NameEditPage(),
        TaggerEditPage.routeName: (context) => const TaggerEditPage(),
      },
      debugShowCheckedModeBanner: false,
      title: "mockingJae 2.0",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: mainBackgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: mainSubThemeColor),
      ),
    );
  }
}
