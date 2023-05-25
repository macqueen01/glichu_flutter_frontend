import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/audioUnit.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/VideoEditingPage.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/functions.dart';
import 'package:provider/provider.dart';

import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class MainBottomNavbar extends StatelessWidget {
  const MainBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 80,
      width: MediaQuery.of(context).size.width,
      blur: 4,
      color: Colors.white.withOpacity(0.1),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          const Color.fromARGB(255, 119, 121, 122).withOpacity(0.3),
        ],
      ),
      //--code to remove border
      border: Border.fromBorderSide(BorderSide.none),
      shadowStrength: 5,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.white.withOpacity(0.24),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: BottomNavIconFromAsset('assets/icons/Home.svg', 30, 30,
                      color: mainBackgroundColor)),
              GestureDetector(
                  onTap: () {},
                  child: BottomNavIconFromAsset(
                      'assets/icons/Global.svg', 30, 30,
                      color: mainBackgroundColor)),
              GestureDetector(
                  onTap: () => pickVideo(context),
                  child: BottomNavIconFromAsset(
                      'assets/icons/addWithOutBorder.svg', 30, 30,
                      color: mainBackgroundColor)),
              GestureDetector(
                  onTap: () {},
                  child: BottomNavIconFromAsset('assets/icons/Me.svg', 30, 30,
                      color: mainBackgroundColor)),
            ],
          ),
        ),
      ),
    );
  }
}
