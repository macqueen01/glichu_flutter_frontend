import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

// IndexChangeHandler is a widget that detects scroll up/down.

class IndexChangeHandler extends StatelessWidget {
  // This widget only handles index items that have limited (and considerably short) height.
  // Examples are short-form videos, loading screen, full height images, and list item etc.
  const IndexChangeHandler(
      {super.key,
      required this.child,
      required this.parentScrollController,
      required this.index});

  final Widget child;
  final MainScrollsController parentScrollController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        double horizontalDragAmount = details.delta.dy;

        if (horizontalDragAmount > 35 && index != 0) {
          parentScrollController.switchToLastScrolls(context);
        } else if (horizontalDragAmount < -20) {
          parentScrollController.switchToNextScrolls(context);
        }
      },
      child: child,
    );
  }
}
