import 'dart:async';
import 'dart:math';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalForm.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/likes.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:sticky_headers/sticky_headers.dart';

import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsHeader.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsPreviewWidgets.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/main.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';
import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/Navbar.dart';
import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';

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
  void initState() {
    super.initState();
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
              appBar: ProfileAppBar(
                  title: const Text(
                "mocking_jae_^.^",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: mainBackgroundColor,
                    textBaseline: TextBaseline.alphabetic),
              )),
              body: ChangeNotifierProvider(
                  create: (BuildContext context) {
                    return ScrollsPreviewManager(context: context);
                  },
                  child: ProfileBody()),
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

class _ProfileBodyState extends State<ProfileBody>
    with DragUpdatable<ProfileBody> {
  @override
  int _duration = 2;

  @override
  void initState() {
    super.initState();
    //_reload();
  }

  @override
  void reload() {
    super.reload();
  }

  @override
  Widget AnimatedLoader(BuildContext context) {
    return super.AnimatedLoader(context);
  }

  @override
  Widget child(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      controller: mainScrollController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: scrollsBackgroundColor),
        child: Column(
          children: [
            AnimatedLoader(context),
            const ProfilePageHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ScrollsMenu(
                parentController: mainScrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollsMenu extends StatefulWidget {
  final ScrollController parentController;

  const ScrollsMenu({super.key, required this.parentController});

  @override
  State<ScrollsMenu> createState() => _ScrollsMenuState();
}

class _ScrollsMenuState extends State<ScrollsMenu> {
  int currentIndex = 0;
  ScrollController menuScrollController = ScrollController();

  void indexChange(int index) {
    moveToTop();
    Timer(const Duration(milliseconds: 250), () {
      moveToIndexedMenu(index);
      setState(() {
        currentIndex = index;
      });
    });
  }

  void moveToTop() {
    widget.parentController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  double _indexToPosition(int index) {
    if (index == 0) {
      return 0;
    } else if (index == 1) {
      return MediaQuery.of(context).size.width;
    }
    return 2 * MediaQuery.of(context).size.width;
  }

  void moveToIndexedMenu(int index) {
    menuScrollController.animateTo(_indexToPosition(index),
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
        alignment: Alignment.centerLeft,
        height: 50,
        color: scrollsBackgroundColor,
        child: Container(
          width: 330,
          alignment: Alignment.centerLeft,
          child: CategorySelect(
            categories: ['Scrolls', 'Videos', 'Favorates'],
            onPressed: indexChange,
          ),
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: menuScrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(seconds: 0),
            curve: Curves.ease,
            height: (currentIndex == 0) ? null : 0,
            child: BoxContainer(
                context: context,
                child: const ScrollsPreviewMenu(),
                width: MediaQuery.of(context).size.width,
                backgroundColor: scrollsBackgroundColor,
                radius: 15),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 0),
            curve: Curves.ease,
            height: (currentIndex == 1) ? null : 0,
            child: BoxContainer(
                context: context,
                child: const ScrollsPreviewMenu(),
                width: MediaQuery.of(context).size.width,
                backgroundColor: scrollsBackgroundColor,
                radius: 15),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 0),
            curve: Curves.ease,
            height: (currentIndex == 2) ? null : 0,
            child: BoxContainer(
                context: context,
                child: const ScrollsPreviewMenu(),
                width: MediaQuery.of(context).size.width,
                backgroundColor: scrollsBackgroundColor,
                radius: 15),
          )
        ]),
      ),
    );
  }
}

class CategorySelect extends StatefulWidget {
  final List<String> categories;
  final void Function(int index)? onPressed;
  final void Function(int index)? onIndexChange;

  const CategorySelect(
      {super.key,
      required this.categories,
      this.onPressed,
      this.onIndexChange});

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
                      onPressed: () {
                        Navigator.pushNamed(context, LikesPage.routeName,
                            arguments: LikePageArguments(
                              user: User(
                                  userName: "JaeKim",
                                  userId: "mockingjae_^.^",
                                  followers: 35134,
                                  followed: 2344523,
                                  scrolled: 1235,
                                  likes: 45145,
                                  remixed: 54627),
                              likes: <User>[
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627),
                                User(
                                    userName: "JaeKim",
                                    userId: "mockingjae_^.^",
                                    followers: 35134,
                                    followed: 2344523,
                                    scrolled: 1235,
                                    likes: 45145,
                                    remixed: 54627)
                              ],
                            ));
                      },
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
                // Follow action button
                FlatButtonSmall(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                        lensFlareSnackbar(
                            context, "You are now following mockingjae"));
                  },
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
                // Send message action button
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
                // Set alarm at update action button
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
                // open more infos and actions button
                // this opens up a bottom sheet modal
                FlatButtonSmall(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        context: context,
                        expand: false,
                        barrierColor: Colors.black54,
                        topRadius: const Radius.circular(20),
                        backgroundColor: mainBackgroundColor,
                        builder: (context) => ListModalBottomSheet(children: [
                              ModalButton(
                                  icon: const Icon(
                                    CupertinoIcons.gear_solid,
                                    size: 30,
                                    color: scrollsBackgroundColor,
                                  ),
                                  text: "settings",
                                  onPressed: () {}),
                              ModalButton(
                                  icon: const Icon(
                                    CupertinoIcons.gear_solid,
                                    size: 30,
                                    color: scrollsBackgroundColor,
                                  ),
                                  text: "settings",
                                  onPressed: () {}),
                              ModalButton(
                                  icon: const Icon(
                                    CupertinoIcons.gear_solid,
                                    size: 30,
                                    color: scrollsBackgroundColor,
                                  ),
                                  text: "settings",
                                  onPressed: () {}),
                              ModalButton(
                                  icon: const Icon(
                                    CupertinoIcons.gear_solid,
                                    size: 30,
                                    color: scrollsBackgroundColor,
                                  ),
                                  text: "settings",
                                  onPressed: () {}),
                            ]));
                  },
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
