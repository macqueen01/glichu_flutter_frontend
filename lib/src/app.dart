import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/main.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/Navbar.dart';
import 'package:mockingjae2_mobile/src/controller/botton_nav_controller.dart';

import 'package:get/get.dart';

import '../utils/functions.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void _onIconTap(int index) {
    setState(() {
      selectedIndex.value = index;
    });
  }

  Color _NavBarColor(ValueNotifier<int> selectedIndex) {
    if (selectedIndex.value == 0) {
      return mainThemeColor;
    } else if (selectedIndex.value == 1) {
      return scrollsBackgroundColor;
    } else if (selectedIndex.value == 2) {
      return mainThemeColor;
    }
    return mainThemeColor;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: (selectedIndex.value == 1) ? true : false,
                appBar: MJAppBar(
                    backgroundColor: _NavBarColor(selectedIndex)),
                body: MainViewGenerator(context, selectedIndex.value),
                bottomNavigationBar: MJBottomNavBar(
                  onTap: _onIconTap,
                  items: [
                    MJIconItem(
                        iconData: iconData(
                            activeDir: 'assets/icons/Home.svg',
                            // inactiveDir: 'assets/icons/Home_stroke.svg',
                            inactiveDir: 'assets/icons/Home.svg',
                            defaultColor: mainThemeColor,
                            height: 28,
                            width: 28)),
                    MJIconItem(
                        iconData: iconData(
                            activeDir: 'assets/icons/Global.svg',
                            // inactiveDir: 'assets/icons/Global_stroke.svg',
                            inactiveDir: 'assets/icons/Global.svg',
                            defaultColor: mainThemeColor,
                            height: 28,
                            width: 28)),
                    MJIconItem(
                        iconData: iconData(
                            activeDir: 'assets/icons/addWithBorder_inverse.svg',
                            inactiveDir: 'assets/icons/addWithBorder.svg',
                            defaultColor: mainThemeColor,
                            height: 28,
                            width: 28)),
                    MJIconItem(
                        iconData: iconData(
                            activeDir: 'assets/icons/locked.svg',
                            // inactiveDir: 'assets/icons/locked_stroke.svg',
                            inactiveDir: 'assets/icons/locked.svg',
                            defaultColor: mainThemeColor,
                            height: 28,
                            width: 28)),
                  ],
                ));
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}

Container MainViewGenerator(BuildContext context, int selectedIndex) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: mainThemeColor,
    ),
    child: BodyWidgets[selectedIndex],
  );
}
