import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

// layout of navbar stateful widget class for ProfileAppBar and Like/Remix AppBar
class SimpleChevronAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Color backgroundColor;
  final Widget title;
  final Alignment titleAlign;
  final void Function(BuildContext)? onBackButtonPressed;

  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  void defaultCallback(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.pop(context);
  }

  const SimpleChevronAppBar({
    Key? key,
    required this.backgroundColor,
    required this.title,
    required this.titleAlign,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  State<SimpleChevronAppBar> createState() => _SimpleChevronAppBarState();
}

class _SimpleChevronAppBarState extends State<SimpleChevronAppBar> {
  // should get selectedIndex -> Color map as an argument for functional architecture

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        // color: Theme.of(context).appBarTheme.backgroundColor,
        color: widget.backgroundColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 50, 20, 5),
          alignment: Alignment.center,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onBackButtonPressed == null) {
                            widget.defaultCallback(context);
                          } else {
                            widget.onBackButtonPressed!(context);
                          }
                        },
                        child: Hero(
                          tag: 'backButton',
                          child: Container(
                            width: 30,
                            height: 40,
                            alignment: Alignment.center,
                            child: Icon(
                              CupertinoIcons.left_chevron,
                              color: mainBackgroundColor,
                              size: 28,
                              weight: 600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: widget.titleAlign,
                        child: Hero(tag: 'title', child: widget.title),
                      ),
                    )
                  ],
                )),
                Hero(tag: 'present', child: PresentNavIcon(Colors.white))
              ]),
        ));
  }
}

SimpleChevronAppBar ProfileAppBar({
  required Widget title,
  void Function(BuildContext)? onBackButtonPressed,
}) {
  return SimpleChevronAppBar(
    backgroundColor: scrollsBackgroundColor,
    title: title,
    titleAlign: Alignment.centerLeft,
    onBackButtonPressed: onBackButtonPressed,
  );
}

SimpleChevronAppBar centeredTitleAppBar({
  required Widget title,
  void Function(BuildContext)? onBackButtonPressed,
}) {
  return SimpleChevronAppBar(
    backgroundColor: scrollsBackgroundColor,
    title: title,
    titleAlign: Alignment.center,
    onBackButtonPressed: onBackButtonPressed,
  );
}

class BigAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Widget headerTextWidget;
  final Widget title;
  final Size preferredSize;
  final void Function(BuildContext)? onBackButtonPressed;
  final void Function(BuildContext)? onForwardButtonPressed;
  final bool forward = false;

  void defaultCallback(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.pop(context);
  }

  const BigAppBar(
      {Key? key,
      required this.backgroundColor,
      required this.headerTextWidget,
      required this.title,
      required this.preferredSize,
      this.onBackButtonPressed,
      required this.onForwardButtonPressed})
      : super(key: key);

  @override
  State<BigAppBar> createState() => _BigAppBarState();
}

class _BigAppBarState extends State<BigAppBar> {
  // should get selectedIndex -> Color map as an argument for functional architecture

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        // color: Theme.of(context).appBarTheme.backgroundColor,
        color: widget.backgroundColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 5),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: widget.headerTextWidget,
              ),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onBackButtonPressed == null) {
                                widget.defaultCallback(context);
                              } else {
                                widget.onBackButtonPressed!(context);
                              }
                            },
                            child: Hero(
                              tag: 'backButton',
                              child: Container(
                                width: 30,
                                height: 40,
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.left_chevron,
                                  color: mainBackgroundColor,
                                  size: 28,
                                  weight: 600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Hero(tag: 'title', child: widget.title),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.forward != true) {
                                return;
                              }
                              if (widget.onForwardButtonPressed == null) {
                                widget.defaultCallback(context);
                              } else {
                                widget.onForwardButtonPressed!(context);
                              }
                            },
                            child: Hero(
                              tag: 'forwardButton',
                              child: Container(
                                width: 30,
                                height: 40,
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.right_chevron,
                                  color: widget.forward
                                      ? mainBackgroundColor
                                      : scrollsBackgroundColor,
                                  size: 28,
                                  weight: 600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ]),
            ],
          ),
        ));
  }
}
