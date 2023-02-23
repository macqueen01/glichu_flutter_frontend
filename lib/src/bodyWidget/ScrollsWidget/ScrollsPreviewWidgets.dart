import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

Widget ScrollsPair({
  required ScrollsPreview firstScrolls,
  required ScrollsPreview secondScrolls,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [firstScrolls, secondScrolls],
  );
}

class ScrollsPreview extends StatefulWidget {
  final String sampleSrc;
  final double width;

  const ScrollsPreview(
      {super.key, required this.sampleSrc, required this.width});

  @override
  State<ScrollsPreview> createState() => _ScrollsPreviewState();
}

class _ScrollsPreviewState extends State<ScrollsPreview> {
  bool _tapped = false;

  void _setFirstTap() {
    setState(() {
      _tapped = true;
    });
    Timer(const Duration(seconds: 6), _resetTap);
  }

  void _resetTap() {
    (mounted)
        ? setState(() {
            _tapped = false;
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_tapped) {
          _setFirstTap();
        }

        return;
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: scrollsBackgroundColor, width: 1)),
        child: Stack(children: [
          // because we are animating the image opacity blending to
          // scrollsBackgroundColor, in white background, the icons (ScrollsInfoButton) might not visible
          AnimatedOpacity(
            opacity: _tapped ? 0.6 : 1,
            duration: const Duration(milliseconds: 100),
            child: Image.asset(
              widget.sampleSrc,
              fit: BoxFit.fitWidth,
              width: widget.width - 2,
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            width: 40,
            child: AnimatedOpacity(
              opacity: _tapped ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.arrow_2_circlepath,
                      statistic: 290231),
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.heart, statistic: 290231),
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.videocam, statistic: 290231)
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
