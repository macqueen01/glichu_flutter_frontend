import 'package:flutter/material.dart';


import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.currentIndex,
    required this.widget,
  });

  final int currentIndex;
  final Scrolls widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: mainBackgroundColor,
          borderRadius: BorderRadius.circular(3)),
      height: 10,
      width: (currentIndex / widget.images.length) *
          MediaQuery.of(context).size.width,
    );
  }
}