import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';

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
                numberParser(number: statistic!),
                style: GoogleFonts.quicksand(
                    fontSize: fontSizeParser(
                        length: numberParser(number: statistic!).length),
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

class FlatButton extends StatefulWidget {
  final Color color;
  final Text? content;
  final Widget? icon;
  final double radius;
  final double height;
  final double width;
  final void Function() onPressed;

  const FlatButton(
      {super.key,
      this.icon,
      this.content,
      required this.onPressed,
      required this.color,
      required this.width,
      required this.height,
      required this.radius});

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.icon == null && widget.content == null) {
      return CupertinoButton(
          onPressed: widget.onPressed,
          padding: EdgeInsets.all(0),
          child: BoxContainer(
              context: context,
              child: Container(),
              backgroundColor: widget.color,
              height: widget.height,
              width: widget.width,
              radius: widget.radius));
    } else if (widget.icon == null) {
      return CupertinoButton(
          onPressed: widget.onPressed,
          padding: EdgeInsets.all(0),
          child: BoxContainer(
              context: context,
              child: widget.content!,
              backgroundColor: widget.color,
              height: widget.height,
              width: widget.width,
              radius: widget.radius));
    } else if (widget.content == null) {
      return CupertinoButton(
          onPressed: widget.onPressed,
          padding: EdgeInsets.all(0),
          child: BoxContainer(
              context: context,
              child: widget.icon!,
              backgroundColor: widget.color,
              height: widget.height,
              width: widget.width,
              radius: widget.radius));
    }

    return CupertinoButton(
        onPressed: widget.onPressed,
        padding: EdgeInsets.all(0),
        child: BoxContainer(
            context: context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.icon!,
                ),
                widget.content!,
              ],
            ),
            backgroundColor: widget.color,
            height: widget.height,
            width: widget.width,
            radius: widget.radius));
  }
}

Widget FlatButtonSmall(
    {Widget? icon,
    String? content,
    required Color backgroundColor,
    Color textColor = mainBackgroundColor,
    required double width,
    required void Function() onPressed,
    double radius = 10}) {
  return FlatButton(
      color: backgroundColor,
      width: width,
      height: 38,
      radius: radius,
      icon: icon,
      onPressed: onPressed,
      content: (content != null)
          ? Text(
              content,
              style: TextStyle(
                  fontSize: 14,
                  textBaseline: TextBaseline.ideographic,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4),
            )
          : null);
}

class IndexStringButton extends StatefulWidget {
  final String content;
  final Color focusColor;
  final Color outFocusColor;
  final void Function(int index) onPressed;
  final double focusSize;
  final double outFocusSize;
  final int index;
  final int selectedIndex;

  // onPressed should be (int => void) Function so that the selected index
  // is passed to the parent widget

  const IndexStringButton(
      {super.key,
      required this.content,
      required this.focusColor,
      required this.outFocusColor,
      required this.focusSize,
      required this.outFocusSize,
      required this.onPressed,
      this.selectedIndex = 0,
      this.index = 0});

  @override
  State<IndexStringButton> createState() => _IndexStringButtonState();
}

class _IndexStringButtonState extends State<IndexStringButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.index);
      },
      child: AnimatedDefaultTextStyle(
        style: GoogleFonts.quicksand(
            color: (widget.index == widget.selectedIndex)
                ? widget.focusColor
                : widget.outFocusColor,
            fontSize: (widget.index == widget.selectedIndex)
                ? widget.focusSize
                : widget.outFocusSize,
            fontWeight: FontWeight.w500),
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
        child: Text(widget.content),
      ),
    );
  }
}

List<Widget> IndexStringButtonProvider(
    {required List<String> stringList,
    required void Function(int index) Function(int item) callback,
    required Color focusColor,
    required Color outFocusColor,
    required double focusSize,
    required double outFocusSize,
    required int selectedIndex,
    required Widget divider}) {
  List<Widget> widgetList = [];

  for (String item in stringList) {

    void Function(int) onPressed = callback(stringList.indexOf(item));

    widgetList.add(IndexStringButton(
        content: item,
        focusColor: focusColor,
        outFocusColor: outFocusColor,
        focusSize: focusSize,
        outFocusSize: outFocusSize,
        onPressed: onPressed,
        selectedIndex: selectedIndex,
        index: stringList.indexOf(item)));

    if (item != stringList.last) {
      widgetList.add(divider);
    }
  }

  return widgetList;
}
