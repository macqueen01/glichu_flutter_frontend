import 'dart:async';

import 'package:flutter/material.dart';

class MainScrollsController extends ScrollController {
  // onScrollsRequest calls the void function that adds
  // new scrolls to the saved scrolls
  Future<void>? onScrollsRequest;
  Function(int index)? onIndexChange;
  Future<void> Function()? refresh;
  int? _currentIndex;
  int? _lastIndex;
  int? _firstIndex;
  int? _lastScrollsIndex;
  bool _indexChanged = true;
  bool indexChangable = false;
  // if timeout is true, then the last scroll can be changed
  // else, the last scroll cannot be changed until preset duration has passed
  bool lastScrollTimeout = true;

  bool isIndexChanged() {
    // if used once, then set _indexChanged to false
    // _indexChanged remains false until switchToNextScrolls or switchToLastScrolls is called
    if (_indexChanged) {
      _indexChanged = false;
      return true;
    }
    return false;
  }

  int? getCurrentScrollsIndex() {
    return _currentIndex;
  }

  int? getLastScrollsIndex() {
    return _lastScrollsIndex;
  }

  void addIndex() {
    if (_currentIndex == null || _lastIndex == null || _firstIndex == null) {
      _currentIndex = 0;
      _firstIndex = 0;
      _lastIndex = 0;
    } else if (_currentIndex == 0 && _lastIndex == 0 && _firstIndex == 0) {
      _lastIndex = 1;
      indexChangable = true;
    } else {
      _lastIndex = 1 + _lastIndex!;
    }
  }

  bool checkChangableForward() {
    if (!indexChangable) {
      return false;
    } else if (_lastIndex == _currentIndex) {
      return false;
    }
    return true;
  }

  bool checkChangableBackward() {
    if (!indexChangable || !lastScrollTimeout) {
      return false;
    } else if (_firstIndex == _currentIndex) {
      return false;
    }
    lastScrollTimeout = false;
    Timer(const Duration(seconds: 1), () {
      lastScrollTimeout = true;
    });
    return true;
  }

  // These switchToFoo extends from scroll Controller that provides
  // straight forward index switching

  void switchToNextScrolls(BuildContext context) {
    if (checkChangableForward()) {
      _lastScrollsIndex = _currentIndex;
      _currentIndex = _currentIndex! + 1;
      _indexChanged = true;
      animateTo((_currentIndex!) * MediaQuery.of(context).size.height,
          duration: const Duration(milliseconds: 230), curve: Curves.ease);
      (onIndexChange != null) ? onIndexChange!(_currentIndex!) : null;
    } else {
      // if onScrollsRequest exists, request more scrolls into the view
    }
  }

  void switchToLastScrolls(BuildContext context) {
    if (checkChangableBackward()) {
      _lastScrollsIndex = _currentIndex;
      _currentIndex = _currentIndex! - 1;
      _indexChanged = true;
      animateTo((_currentIndex!) * MediaQuery.of(context).size.height,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
      (onIndexChange != null) ? onIndexChange!(_currentIndex!) : null;
    }
    return;
  }

  // Refresh calls its parent Widget ScrollsBodyView's _refresh method
  Future<void> refreshScroll() async {
    (refresh != null) ? refresh!() : null;
  }

  void setRefresh(Future<void> Function() refreshFunction) {
    refresh = refreshFunction;
  }

  /// Creates a controller for a scrollable widget.
  MainScrollsController(
      {this.onScrollsRequest, this.refresh, this.onIndexChange});
}

class SingleScrollsController extends ScrollController {
  // SingleScrollsController is responsible for every actions and events
  // for a single scrolls item.

  // duration is the playtime of the entire scrolls estimated to integer milliseconds
  // default playtime is 15 seconds.
  int duration;
  // height is an entire height of the scrolls item. this value should be passed inside
  // the scrolls widget this controller is called.
  double height;
  // Build Context for screen height
  BuildContext context;

  void scrubToEnd() {
    animateTo(height,
        duration: Duration(milliseconds: (remaining() * duration).floor()),
        curve: Curves.ease);
  }

  void fastScrubToEnd() {
    animateTo(height,
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  void scrubToStart() {
    animateTo(height,
        duration:
            Duration(milliseconds: ((1 - remaining()) * duration).floor()),
        curve: Curves.ease);
  }

  void fastScrubToStart() {
    animateTo(0,
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  void scrubStop() {
    jumpTo(offset);
  }

  double remaining() {
    return (10000 -
            ((10000 / (height - MediaQuery.of(context).size.height)) *
                offset)) /
        10000;
  }

  SingleScrollsController(
      {this.duration = 15000, required this.height, required this.context});
}
