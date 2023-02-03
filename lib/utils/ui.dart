import 'package:flutter/material.dart';

import 'package:figma_squircle/figma_squircle.dart';




Widget BoxContainer({required BuildContext context, required Widget child, required double height, required double width, required Color backgroundColor}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width: width,
    height: height,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 20,
          cornerSmoothing: 0.8,
        ),
      ),
    ),
    child: child,
  );
}