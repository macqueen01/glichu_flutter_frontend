import 'package:flutter/material.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

List<GestureDetector> touchableBottomWidgetGenerator(List<MJIconItem> items, Function onTapCallBack, int currentIndex, int mode) {
  // if mode == 0 -> day mode
  // if mode == 1 -> night mode
  return List.generate(items.length , (index) {
    return GestureDetector(
      onTap: () {
        onTapCallBack(index);
      },
      child: SizedBox(
        width: 30,
        height: 30,
        child: items[index].activeDetect(currentIndex == index, mode)
      )
    );
  });
}

class MJIconItem {
  final Function iconData;

  MJIconItem({
    required this.iconData,
  });

  Widget activeDetect(bool trueCondition, int mode) {
    return this.iconData(trueCondition, mode);
  }
}