import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/app.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/audioUnit.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/VideoEditingPage.dart';
import 'package:mockingjae2_mobile/src/pages/home.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/functions.dart';
import 'package:provider/provider.dart';

import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class MainBottomNavbar extends StatelessWidget {
  const MainBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SelfProfilePage.routeName);
                },
                child: Container(
                  child: BottomNavIconFromPngAsset('assets/icons/home.png', 34),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(145, 77, 77, 77),
                        blurRadius: 20,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                )),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Container(
                  child:
                      BottomNavIconFromPngAsset('assets/icons/globe.png', 34),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(95, 77, 77, 77),
                        blurRadius: 16,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                )),
            GestureDetector(
              onTap: () => pickVideo(context),
              child: Container(
                child: BottomNavIconFromPngAsset('assets/icons/plus.png', 34),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(95, 77, 77, 77),
                      blurRadius: 16,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
