import 'package:flutter/material.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

Widget Button({required void Function() onTap}) {
  return GestureDetector(
    onTap: () => {onTap()},
    child: Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: mainBackgroundColor),
      child: Text('CLICK!'),
    ),
  );
}

Widget SampleButton({required void Function() onTap}) {
  return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 230,
        height: 50,
        decoration: BoxDecoration(
            color: mainSubThemeColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: mainThemeColor, width: 1.5)),
        alignment: Alignment.center,
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            color: mainThemeColor,
          ),
        ),
      ));
}

class FlatButtonLarge extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color backgroundColor;
  final Color fontColor;
  final Decoration decoration;

  const FlatButtonLarge(
      {super.key,
      required this.text, 
      required this.onPressed, 
      required this.backgroundColor,
      required this.fontColor,
      required this.decoration});

  @override
  State<FlatButtonLarge> createState() => _FlatButtonLargeState();
}

class _FlatButtonLargeState extends State<FlatButtonLarge> {
  bool _tapped = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails) {
          widget.onPressed();
          setState(() {
            _tapped = true;
          });
        },
        onTapUp: (TapUpDetails) {
          setState(() {
            _tapped = false;
          });
        },
        onTap: () {
          widget.onPressed();
        },
        child: AnimatedContainer(
          width: _tapped ? 220 : 230,
          height: _tapped ? 47.5 : 50,
          decoration: widget.decoration,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 100),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              color: widget.fontColor,
            ),
          ),
        ));
  }
}
