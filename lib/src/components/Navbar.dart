import 'package:flutter/material.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/functions.dart';


// Bottom Nav Bar

class MJBottomNavBar extends StatefulWidget {
  final List<MJIconItem> items;
  final Function onTap;
  final int initialIndex;

  const MJBottomNavBar({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onTap
  });

  @override
  State<MJBottomNavBar> createState() => _MJBottomNavBar();
}

class _MJBottomNavBar extends State<MJBottomNavBar> {
  late int _currentIndex;
  late int _mode = 0;
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _mode = 0;
    _backgroundColor = mainSubThemeColor;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        _mode = 1;
      } else {
        _mode = 0;
      }
      widget.onTap(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 30),
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
          color: (_mode == 0) ? mainSubThemeColor : Colors.transparent,
          border: (_mode == 0) ? Border(
              top: BorderSide(
                  color: mainSubThemeColor,
                  width: 2,
                  style: BorderStyle.solid)) : Border()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: touchableBottomWidgetGenerator(
            widget.items, _onItemTapped, _currentIndex, _mode),
      ),
    );
  }
}

// Top App Bar

class MJAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  MJAppBar({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  State<MJAppBar> createState() => _MJAppBarState();
}

class _MJAppBarState extends State<MJAppBar> {
  // should get selectedIndex -> Color map as an argument for functional architecture

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        // color: Theme.of(context).appBarTheme.backgroundColor,
        color: widget.backgroundColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 5),
          alignment: Alignment.center,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoNavIcon(60, 30, mainBackgroundColor),
                PresentNavIcon(Colors.white)
              ]),
        ));
    }
  }

