import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/RemixBodyView.dart';

import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/crop.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/export_result.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

import 'package:provider/provider.dart';
import 'package:helpers/helpers.dart' show OpacityTransition;

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:video_editor/video_editor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mockingjae2_mobile/src/components/inputs.dart';

class ProcessingPage extends StatefulWidget {
  late final ScrollsUploader uploader;

  ProcessingPage({super.key, required File file}) {
    this.uploader = ScrollsUploader(currentLoadedVideo: file);
  }

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
