import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/api/profile.dart';
import 'package:mockingjae2_mobile/src/components/navbars/bottomBars.dart';
import 'package:mockingjae2_mobile/src/pages/profile.dart';

import 'package:provider/provider.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/Navbar.dart';

class SelfProfilePage extends StatefulWidget {
  const SelfProfilePage({super.key});

  static const routeName = '/myhouse';

  @override
  State<SelfProfilePage> createState() => _SelfProfilePageState();
}

class _SelfProfilePageState extends State<SelfProfilePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
              backgroundColor: scrollsBackgroundColor,
              resizeToAvoidBottomInset: true,
              extendBody: true,
              appBar: MJAppBar(backgroundColor: scrollsBackgroundColor),
              body: FutureBuilder(
                  future: RelationsFetcher().fetchUserSelf(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ChangeNotifierProvider(
                          create: (BuildContext context) {
                            return ScrollsPreviewManager(
                                context: context, user: snapshot.data!);
                          },
                          child: const ProfileBodyWrapper());
                    }
                    return Container(
                      alignment: Alignment.center,
                      child: const CupertinoActivityIndicator(
                          color: mainSubThemeColor,
                          radius: 10.0,
                          animating: true),
                    );
                  }),
              bottomNavigationBar:
                  Hero(tag: 'bottomBar', child: MainBottomNavbar()),
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}
