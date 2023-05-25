import 'package:flutter/material.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class AnimatedTextField extends StatefulWidget {
  final Function callBack;
  final String placeholder;
  final double width;
  final bool hidden;

  final Color placeholderColor;
  final Color placeholderColorFocused;
  final Color mainTextColor;
  final Color borderColor;

  const AnimatedTextField(
      {super.key,
      this.placeholderColor = Colors.black38,
      this.placeholderColorFocused = Colors.black87,
      this.mainTextColor = Colors.black38,
      this.borderColor = mainThemeColor,
      required String this.placeholder,
      required Function this.callBack,
      required double this.width,
      required bool this.hidden});

  double textSize(String text) {
    if (text == '') {
      return 18;
    }
    return 14;
  }

  Color textColor(String text) {
    if (text == '') {
      return placeholderColor;
    }
    return placeholderColorFocused;
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
  Color? _textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        width: widget.width,
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: widget.borderColor,
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
                    style: TextStyle(
                        fontSize: _textSize,
                        color: _textColor != null
                            ? _textColor
                            : widget.textColor(_text)),
                    duration: const Duration(milliseconds: 150),
                    child: Text(widget.placeholder)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, _textFieldPaddingBottom),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  obscureText: !widget.hidden,
                  onChanged: (text) {
                    setState(() {
                      widget.callBack(text);
                      _textSize = widget.textSize(text);
                      _textPaddingTop = widget.textTopPadding(text);
                      _textFieldPaddingTop = widget.textFieldTopPadding(text);
                      _textFieldPaddingBottom =
                          widget.textFieldBottomPadding(text);
                      _textColor = widget.textColor(text);
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
