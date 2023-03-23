// Scroll page only accessable through profile page

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/RemixBodyView.dart';

import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

import 'package:provider/provider.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';

class ProfileScrollsPageArguments {
  final User user;
  final List<ScrollsModel> scrollsModels;

  ProfileScrollsPageArguments(
      {required this.user, required this.scrollsModels});
}

class ProfileScrollsPage extends StatefulWidget {
  const ProfileScrollsPage({Key? key}) : super(key: key);

  static const routeName = '/profileScrolls';

  @override
  State<ProfileScrollsPage> createState() => _ProfileScrollsPageState();
}

class _ProfileScrollsPageState extends State<ProfileScrollsPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void _onIconTap(int index) {
    setState(() {
      selectedIndex.value = index;
    });

    if (selectedIndex.value == 1) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ProfileScrollsPageArguments;
    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
              backgroundColor: scrollsBackgroundColor,
              resizeToAvoidBottomInset: true,
              extendBody: true,
              appBar: ProfileAppBar(
                  title: const Text(
                "mocking_jae_^.^",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: mainBackgroundColor,
                    textBaseline: TextBaseline.alphabetic),
              )),
              body: ChangeNotifierProvider(
                  create: (BuildContext context) {
                    return ScrollsPreviewManager(context: context);
                  },
                  child: RemixBodyView()),
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}
