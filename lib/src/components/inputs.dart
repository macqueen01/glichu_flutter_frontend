import 'package:flutter/material.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class AnimatedTextField extends StatefulWidget {
  final Function callBack;
  final String placeholder;
  final double width;
  final bool hidden;

  const AnimatedTextField(
      {super.key,
      required String this.placeholder,
      required Function this.callBack,
      required double this.width,
      required bool this.hidden});

  @override
  State<AnimatedTextField> createState() => AnimatedTextFieldState();
}

class AnimatedTextFieldState extends State<AnimatedTextField> {
  String _text = '';
  double _textPaddingTop = 8;
  double _textPaddingLeft = 0;
  double _textFieldPaddingTop = 12;
  double _textFieldPaddingBottom = 13;
  double _textSize = 18;
  Color _textColor = Colors.black38;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        width: widget.width,
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: mainThemeColor,
              width: 1.5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(6)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, _textPaddingTop, 0, 10),
                child: AnimatedDefaultTextStyle(
                    style: TextStyle(fontSize: _textSize, color: _textColor),
                    duration: const Duration(milliseconds: 150),
                    child: Text(widget.placeholder)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, _textFieldPaddingBottom),
                child: TextField(
                  style: const TextStyle(fontSize: 16),
                  obscureText: !widget.hidden,
                  onChanged: (text) {
                    setState(() {
                      widget.callBack(text);
                      _textSize = textSize(text);
                      _textPaddingTop = textTopPadding(text);
                      _textFieldPaddingTop = textFieldTopPadding(text);
                      _textFieldPaddingBottom = textFieldBottomPadding(text);
                      _textColor = textColor(text);
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: false),
                ),
              ),
            ],
          ),
        ));
  }
}

double textSize(String text) {
  if (text == '') {
    return 18;
  }
  return 14;
}

Color textColor(String text) {
  if (text == '') {
    return Colors.black38;
  }
  return Colors.black87;
}

double textTopPadding(String text) {
  if (text == '') {
    return 10;
  }
  return 0;
}

double textFieldTopPadding(String text) {
  if (text == '') {
    return 12;
  }
  return 20;
}

double textFieldBottomPadding(text) {
  if (text == '') {
    return 13;
  }
  return 5;
}
