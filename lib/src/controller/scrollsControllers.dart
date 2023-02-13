import 'package:flutter/material.dart';

class MainScrollsController extends ScrollController {
  // onScrollsRequest calls the void function that adds
  // new scrolls to the saved scrolls
  Future<void>? onScrollsRequest;
  int? _currentIndex;
  int? _lastIndex;
  int? _firstIndex;
  bool indexChangable = false;

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
    if (!indexChangable) {
      return false;
    } else if (_firstIndex == _currentIndex) {
      return false;
    }
    return true;
  }

  void addIndecies(List<List<Image>> scrollImageLists) {
    scrollImageLists.forEach((element) {
      addIndex();
    });
  }

  // These switchToFoo extends from scroll Controller that provides
  // straight forward index switching

  void switchToNextScrolls(BuildContext context) {
    // TODO: implement auto animateTo to the next scrolls if one exists.
    if (checkChangableForward()) {
      _currentIndex = _currentIndex! + 1;
      animateTo((_currentIndex!) * MediaQuery.of(context).size.height,
          duration: const Duration(milliseconds: 230), curve: Curves.ease);
    } else {
      // if onScrollsRequest exists, request more scrolls into the view
      print("end!");
    }
  }

  void switchToLastScrolls(BuildContext context) {
    // TODO: implement auto animateTo to the last scrolls if one exists.
    if (checkChangableBackward()) {
      _currentIndex = _currentIndex! - 1;
      animateTo((_currentIndex!) * MediaQuery.of(context).size.height,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
    return;
  }

  /// Creates a controller for a scrollable widget.
  ///
  /// The values of `initialScrollOffset` and `keepScrollOffset` must not be null.
  MainScrollsController({
    this.onScrollsRequest,
  });
}
