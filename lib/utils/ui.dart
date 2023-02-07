import 'package:flutter/material.dart';

import 'package:figma_squircle/figma_squircle.dart';




Widget BoxContainer({required BuildContext context, required Widget child, double? height, double? width, required Color backgroundColor, double radius = 20}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width: width,
    height: height,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 0.8,
        ),
      ),
    ),
    child: child,
  );
}