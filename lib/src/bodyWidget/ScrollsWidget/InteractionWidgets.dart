// Packages imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/modals/autoRecordingPopUp.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// Scrolls Button related local import

class ScrollsRelatedInfoButtonWrap extends StatelessWidget {
  final int scrollsId;

  const ScrollsRelatedInfoButtonWrap({super.key, required this.scrollsId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ScrollsInfoButton(
            iconData: CupertinoIcons.arrow_2_circlepath, statistic: 29390),
        ScrollsInfoButton(iconData: CupertinoIcons.heart, statistic: 3),
        ScrollsInfoButton(
          iconData: CupertinoIcons.videocam,
          statistic: 390278,
          callBack: () {
            showCupertinoModalBottomSheet(
                context: context,
                topRadius: const Radius.circular(20),
                duration: const Duration(milliseconds: 350),
                backgroundColor: scrollsBackgroundColor,
                builder: (context) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (context) =>
                              AutoRecordingPlayManager(scrollsId: scrollsId)),
                    ],
                    child: AutoRecordingPopUpView(
                      scrollsId: scrollsId,
                    ),
                  );
                });
          },
        ),
        ScrollsInfoButton(
            iconData: CupertinoIcons.add_circled, statistic: 209438)
      ],
    );
  }
}
