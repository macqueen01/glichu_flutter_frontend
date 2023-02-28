// Scroll page only accessable through profile page

import 'dart:async';
import 'dart:math';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalForm.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/likes.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:sticky_headers/sticky_headers.dart';

import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsHeader.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsPreviewWidgets.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/main.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';
import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/Navbar.dart';
import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';

import 'package:mockingjae2_mobile/utils/functions.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';

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
                  child: ScrollsBodyView()),
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}
