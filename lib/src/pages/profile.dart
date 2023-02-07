import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsHeader.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsPreviewWidgets.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/main.dart';
import 'package:mockingjae2_mobile/src/components/buttons.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';
import 'package:mockingjae2_mobile/src/controller/scrollControlers.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/Navbar.dart';
import 'package:mockingjae2_mobile/src/controller/botton_nav_controller.dart';

import 'package:mockingjae2_mobile/utils/functions.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void _onIconTap(int index) {
    setState(() {
      selectedIndex.value = index;
    });

    if (selectedIndex.value == 1) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
              backgroundColor: scrollsBackgroundColor,
              resizeToAvoidBottomInset: true,
              extendBody: false,
              appBar:
                  const ProfileAppBar(backgroundColor: scrollsBackgroundColor),
              body: ProfileBody(),
              /*
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
                )*/
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _load = false;

  void _reload() {
    // this should recieve all data from the server,
    // then refreshed all contents of the page
    setState(() {
      _load = true;
      Timer(const Duration(seconds: 2), () {
        setState(() {
          _load = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //_reload();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels <
            -MediaQuery.of(context).size.height * 0.065) {
          _reload();
        }
        return true;
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: scrollsBackgroundColor),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                height:
                    (_load) ? MediaQuery.of(context).size.height * 0.065 : 0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/Me.svg',
                  width: 30,
                  height: 30,
                  color: mainBackgroundColor,
                ),
              ),
              ProfilePageHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ScrollsMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollsMenu extends StatefulWidget {
  const ScrollsMenu({super.key});

  @override
  State<ScrollsMenu> createState() => _ScrollsMenuState();
}

class _ScrollsMenuState extends State<ScrollsMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        alignment: Alignment.centerLeft,
        height: 50,
        child: Container(
          width: 300,
          alignment: Alignment.centerLeft,
          child: CategorySelect(
            categories: ['Scrolls', 'Videos', 'Images'],
            onPressed: (int index) {},
          ),
        ),
      ),
      BoxContainer(
          context: context,
          child: Column(
            children: [
              ScrollsPair(
                firstScrolls: Hero(
                  tag: 0,
                  child: ScrollsPreview(
                      sampleSrc: "sample_scrolls/scrolls1/1.jpeg",
                      width: MediaQuery.of(context).size.width / 2),
                ),
                secondScrolls: Hero(
                    tag: 3,
                    child: ScrollsPreview(
                        sampleSrc: "sample_scrolls/scrolls1/1.jpeg",
                        width: MediaQuery.of(context).size.width / 2)),
              ),
              ScrollsPair(
                firstScrolls: Hero(
                    tag: 5,
                    child: ScrollsPreview(
                        sampleSrc: "sample_scrolls/scrolls1/1.jpeg",
                        width: MediaQuery.of(context).size.width / 2)),
                secondScrolls: Hero(
                    tag: 9,
                    child: ScrollsPreview(
                        sampleSrc: "sample_scrolls/scrolls1/1.jpeg",
                        width: MediaQuery.of(context).size.width / 2)),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
          backgroundColor: scrollsBackgroundColor,
          radius: 13),
    ]);
  }
}

class CategorySelect extends StatefulWidget {
  final List<String> categories;
  final void Function(int index)? onPressed;

  const CategorySelect({super.key, required this.categories, this.onPressed});

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: IndexStringButtonProvider(
          stringList: widget.categories,
          callback: (int item) {
            return (int index) {
              if (index == item) {
                setState(() {
                  _selected = item;
                });
              }
              widget.onPressed!(index);
            };
          },
          focusColor: mainBackgroundColor,
          outFocusColor: Colors.white60,
          focusSize: 30,
          outFocusSize: 25,
          selectedIndex: _selected,
          divider: const VerticalDivider(
            width: 2.5,
            thickness: 1.6,
            indent: 14,
            endIndent: 4,
            color: Colors.white60,
          )),
    );
  }
}

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 280,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Profile(
                  image: Image.asset(
                    'assets/icons/dalli.jpg',
                    width: 90,
                    height: 90,
                  ),
                  size: 1,
                ),
                Container(
                  width: 190,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "mocking_jae_^.^",
                        style: TextStyle(
                            fontSize: 17,
                            color: mainBackgroundColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Master of Architect in JECT",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            alignment: Alignment.center,
            child: BoxContainer(
                context: context,
                height: 80,
                width: 338,
                backgroundColor: mainBackgroundColor,
                radius: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoWithIcon(
                      iconData: CupertinoIcons.arrow_2_circlepath,
                      statistic: 29872,
                      iconColor: Colors.black87,
                      iconSize: 28,
                      textColor: Colors.black87,
                      textSize: 13,
                    ),
                    VerticalDivider(
                      width: 2,
                      thickness: 1.6,
                      indent: 20,
                      endIndent: 20,
                    ),
                    InfoWithIcon(
                      iconData: CupertinoIcons.heart_fill,
                      statistic: 29872,
                      iconColor: Colors.black87,
                      iconSize: 28,
                      textColor: Colors.black87,
                      textSize: 13,
                    ),
                    VerticalDivider(
                      width: 2,
                      thickness: 1.6,
                      indent: 20,
                      endIndent: 20,
                    ),
                    InfoWithIcon(
                      iconData: CupertinoIcons.videocam_circle_fill,
                      statistic: 29872,
                      iconColor: Colors.black87,
                      iconSize: 28,
                      textColor: Colors.black87,
                      textSize: 13,
                    ),
                  ],
                )),
          ),
          Container(
            width: 338,
            height: 80,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButtonSmall(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/Me.svg',
                    width: 16,
                    height: 16,
                    color: mainBackgroundColor,
                  ),
                  content: "Follow",
                  backgroundColor: lensFlareMain,
                  width: 135,
                  textColor: mainBackgroundColor,
                ),
                FlatButtonSmall(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/Dm.svg',
                    width: 16,
                    height: 16,
                    color: scrollsBackgroundColor,
                  ),
                  content: "Send",
                  backgroundColor: mainBackgroundColor,
                  width: 90,
                  textColor: scrollsBackgroundColor,
                ),
                FlatButtonSmall(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.bell,
                    color: scrollsBackgroundColor,
                    size: 20,
                    weight: 600,
                  ),
                  backgroundColor: mainBackgroundColor,
                  width: 40,
                  textColor: scrollsBackgroundColor,
                ),
                FlatButtonSmall(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/more.svg",
                    width: 16,
                    height: 16,
                    color: scrollsBackgroundColor,
                  ),
                  backgroundColor: mainBackgroundColor,
                  width: 40,
                  textColor: scrollsBackgroundColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InfoWithIcon extends StatefulWidget {
  late int statistic;

  IconData iconData;
  double iconSize;
  double textSize;
  Color iconColor;
  Color textColor;

  InfoWithIcon(
      {super.key,
      required this.iconData,
      required this.statistic,
      required this.iconSize,
      required this.textSize,
      required this.iconColor,
      required this.textColor});

  @override
  State<InfoWithIcon> createState() => _InfoWithIconState();
}

class _InfoWithIconState extends State<InfoWithIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 45,
      child: Column(children: [
        Icon(
          widget.iconData,
          size: widget.iconSize,
          color: widget.iconColor,
        ),
        Text(
          numberParser(number: widget.statistic),
          style: GoogleFonts.quicksand(
              fontSize: widget.textSize,
              color: widget.textColor,
              fontWeight: FontWeight.w600),
        )
      ]),
    );
  }
}
