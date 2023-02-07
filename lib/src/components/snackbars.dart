import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';


SnackBar greenSnackbar(BuildContext context, String content) {
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
          height: 35,
          width: 230,
          backgroundColor: Color.fromARGB(255, 72, 203, 76),
          radius: 9,
          child: Text(
            content,
            style: TextStyle(
              color: mainBackgroundColor,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          )
          ),
      ));
}


SnackBar redSnackbar(BuildContext context, String content) {
  return SnackBar(
      dismissDirection: DismissDirection.none,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      duration: const Duration(milliseconds: 1000),
      content: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: BoxContainer(
          context: context,
          height: 35,
          width: 230,
          backgroundColor: Color.fromARGB(255, 255, 64, 50),
          radius: 9,
          child: Text(
            content,
            style: TextStyle(
              color: mainBackgroundColor,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          )
          ),
      ));
}