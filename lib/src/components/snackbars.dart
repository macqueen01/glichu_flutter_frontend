import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';

SnackBar coloredSnackbar(BuildContext context, String content, Color textColor,
    Color backgroundColor) {
  double width = 230;

  switch ((content.length / 10).floor()) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      width = 230;
      break;
    default:
      width = 260;
  }
  return SnackBar(
      dismissDirection: DismissDirection.none,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      duration: const Duration(milliseconds: 1000),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        child: BoxContainer(
            context: context,
            height: 38,
            width: width,
            backgroundColor: backgroundColor,
            radius: 9,
            child: Text(
              content,
              style: TextStyle(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            )),
      ));
}

SnackBar greenSnackbar(BuildContext context, String content) {
  return coloredSnackbar(
      context, content, mainBackgroundColor, Color.fromARGB(255, 72, 203, 76));
}

SnackBar redSnackbar(BuildContext context, String content) {
  return coloredSnackbar(
      context, content, mainBackgroundColor, Color.fromARGB(255, 255, 64, 50));
}

SnackBar lensFlareSnackbar(BuildContext context, String content) {
  return coloredSnackbar(context, content, mainBackgroundColor, lensFlareMain);
}
