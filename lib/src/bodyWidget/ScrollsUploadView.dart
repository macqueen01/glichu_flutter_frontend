import 'dart:io';

// Packages imports

import 'package:audio_session/audio_session.dart';
import 'package:flutter/rendering.dart';

import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/GestureDetectViews/scrollWidget.dart';
import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/Recorder/recorder.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Restricted.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/StaticLoading.dart';

import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/settings.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:provider/provider.dart';

// Scrolls Button related local import

import 'ScrollsWidget/InteractionWidgets.dart';
import 'ScrollsWidget/ScrollsHeader.dart';

class ScrollsUploadView extends StatefulWidget {
  const ScrollsUploadView({super.key});

  @override
  State<ScrollsUploadView> createState() => _ScrollsUploadViewState();
}

class _ScrollsUploadViewState extends State<ScrollsUploadView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: scrollsBackgroundColor,
      child: Center(
        child: Column(
          children: [
            Text('Upload Now !',
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: mainBackgroundColor,
                )),
          ],
        ),
      ),
    );
  }
}
