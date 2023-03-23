import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

// PlaceHoldLoadable provides custom placeholder view on future then gives desired view on load finish

mixin PlaceHoldLoadable<T extends StatefulWidget> on State<T> {
  bool _load = false;
}

// DragUpdatable provides update on overscroll.

mixin DragUpdatable<T extends StatefulWidget> on State<T> {
  bool _load = false;
  int _duration = 2;
  ScrollController mainScrollController = ScrollController();

  void reload() {
    // this should recieve all data from the server,
    // then refreshed all contents of the page
    setState(() {
      _load = true;
      Timer(Duration(seconds: _duration), () {
        (mounted)
            ? setState(() {
                _load = false;
              })
            : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels <
            -MediaQuery.of(context).size.height * 0.065) {
          reload();
        }
        return true;
      },
      child: child(context),
    );
  }

  Widget AnimatedLoader(BuildContext context) {
    // Default animated loader
    // Modifications could be made by overriding it.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      height: (_load) ? MediaQuery.of(context).size.height * 0.065 : 0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/icons/Me.svg',
        width: 30,
        height: 30,
        color: mainBackgroundColor,
      ),
    );
  }

  Widget child(BuildContext context) {
    return const Placeholder();
  }
}

// ScrollsControlManager mixin provides a super controller to
// scrolls body view that enables fluent control on scrolls index change
