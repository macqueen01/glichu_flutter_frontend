import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';

Widget BottomNavIconFromAsset(String dir, double width, double height,
    {color = mainThemeColor}) {
  return SvgPicture.asset(dir, width: width, height: height, color: color);
}

Widget LogoNavIcon(double width, double height, Color color) {
  return SvgPicture.asset('assets/icons/Jae.svg',
      width: width, height: height, color: color);
}

Widget JaeIcon(double width, double height, Color color) {
  return SvgPicture.asset(
    'assets/icons/Me.svg',
    width: width,
    height: height,
    color: color,
  );
}

Widget PresentNavIcon(Color color) {
  return SvgPicture.asset('assets/icons/glichu.svg', width: 40, height: 40);
}

Widget GlichuIcon(double width, double height) {
  return SvgPicture.asset(
    'assets/icons/glichu.svg',
    width: width,
    height: height,
  );
}

Function iconDataColor(String dir, double height, double width) {
  return (color) {
    return SvgPicture.asset(
      dir,
      height: height,
      width: width,
      color: color,
    );
  };
}

Function iconData(
    {required String activeDir,
    required String inactiveDir,
    required Color defaultColor,
    required double height,
    required double width}) {
  // mode be 0 if light
  // mode be 1 if dark

  return (isActive, mode) {
    String dir = inactiveDir;
    Color color = defaultColor;

    if (isActive) {
      dir = activeDir;
      color = mainThemeColor;
    }

    if (mode == 1) {
      color = iconVoidColor;
    }

    return SvgPicture.asset(
      dir,
      height: height,
      width: width,
      color: color,
    );
  };
}
