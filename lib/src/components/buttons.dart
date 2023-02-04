import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';


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

// Side Buttons in Scrolls View

class ScrollsInfoButton extends StatefulWidget {
  final IconData iconData;
  final int statistic;
  final Function? callBack;


  const ScrollsInfoButton({
    super.key,
    required this.iconData,
    required this.statistic,
    this.callBack,
  });

  @override
  State<ScrollsInfoButton> createState() => _ScrollsInfoButtonState();
}

class _ScrollsInfoButtonState extends State<ScrollsInfoButton> {
  IconData? iconData;
  int? statistic;

  @override
  void initState() {
    super.initState();
    iconData = widget.iconData;
    statistic = widget.statistic;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.callBack != null) {
          widget.callBack!();
        }
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Column(
            children: [
              Icon(
                iconData,
                size: 24,
                color: mainBackgroundColor,
              ),
              Text(
                '$statistic',
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: mainBackgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}