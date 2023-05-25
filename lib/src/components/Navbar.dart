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

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/functions.dart';
import 'package:provider/provider.dart';

// Bottom Nav Bar

class MJBottomNavBar extends StatefulWidget {
  final List<MJIconItem> items;
  final Function onTap;
  final int initialIndex;

  const MJBottomNavBar(
      {super.key,
      required this.items,
      this.initialIndex = 1,
      required this.onTap});

  @override
  State<MJBottomNavBar> createState() => _MJBottomNavBar();
}

class _MJBottomNavBar extends State<MJBottomNavBar> {
  late int _currentIndex;
  late int _mode = 0;
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
    _mode = 1;
    _backgroundColor = mainSubThemeColor;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        _mode = 1;
      } else {
        _mode = 0;
      }
      widget.onTap(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == 1) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 30),
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 33.5,
              top: 2,
              child: GestureDetector(
                  onTap: () {
                    _onItemTapped(0);
                  },
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child:
                          widget.items[0].activeDetect(_currentIndex == 1, 1))),
            ),
            /*
            Positioned(
                right: 30,
                top: -30,
                child: recordingButton(
                  onStart: context.read<RecorderProvider>().startRecording,
                  onEnd: context.read<RecorderProvider>().stopRecording,
                )),*/
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 30),
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
          color: (_mode == 0) ? mainSubThemeColor : Colors.transparent,
          border: (_mode == 0)
              ? const Border(
                  top: BorderSide(
                      color: mainSubThemeColor,
                      width: 2,
                      style: BorderStyle.solid))
              : const Border()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: touchableBottomWidgetGenerator(
            widget.items, _onItemTapped, _currentIndex, _mode),
      ),
    );
  }
}

// Top App Bar

class MJAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  const MJAppBar({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  State<MJAppBar> createState() => _MJAppBarState();
}

class _MJAppBarState extends State<MJAppBar> {
  // should get selectedIndex -> Color map as an argument for functional architecture

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        // color: Theme.of(context).appBarTheme.backgroundColor,
        color: widget.backgroundColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 5),
          alignment: Alignment.center,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoNavIcon(60, 30, mainBackgroundColor),
                PresentNavIcon(Colors.white)
              ]),
        ));
  }
}

class recordingButton extends StatefulWidget {
  final void Function()? onStart;
  final void Function()? onEnd;

  const recordingButton({super.key, this.onStart, this.onEnd});

  @override
  State<recordingButton> createState() => _recordingButtonState();
}

class _recordingButtonState extends State<recordingButton> {
  // state == 0 if not recording
  // state == 1 if recording button clicked, but waiting for start recording
  // state == 2 if recoring at the time
  int state = 0;
  Color _color = mainBackgroundColor;
  bool _tapped = false;

  void setScrollState() {
    setState(() {
      state = 0;
      _color = mainBackgroundColor;
    });
    (widget.onEnd == null) ? null : widget.onEnd!();
  }

  void setRecordingState() {
    setState(() {
      state = 2;
      _color = const Color.fromARGB(255, 241, 76, 64);
    });
    (widget.onStart == null) ? null : widget.onStart!();
  }

  @override
  void initState() {
    super.initState();
    setScrollState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _tapped = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _tapped = false;
        });
      },
      onTap: () async {
        HapticFeedback.lightImpact();
        if (state == 2) {
          setScrollState();
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(greenSnackbar(context, "Recording ended"));
        } else {
          setRecordingState();
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(redSnackbar(context, "Recording started"));
        }
      },
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          curve: Curves.linear,
          alignment: Alignment.center,
          width: _tapped ? 60 : 70,
          height: _tapped ? 60 : 70,
          decoration: BoxDecoration(
              border: Border.all(color: mainBackgroundColor, width: 4.5),
              shape: BoxShape.circle,
              color: Colors.transparent),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 10),
            curve: Curves.linear,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
            width: 55,
            height: 55,
          ),
        ),
      ),
    );
  }
}
