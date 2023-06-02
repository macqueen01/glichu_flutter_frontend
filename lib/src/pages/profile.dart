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
import 'package:mockingjae2_mobile/src/api/social_interactions.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalForm.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/VideoEditingPage.dart';
import 'package:mockingjae2_mobile/src/pages/editProfile.dart';
import 'package:mockingjae2_mobile/src/pages/followers.dart';
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

import 'package:mockingjae2_mobile/src/api/scrolls.dart' as api;

class ProfilePageArguments {
  final UserMin user;

  ProfilePageArguments({required this.user});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile';

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
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfilePageArguments?;

    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
              backgroundColor: scrollsBackgroundColor,
              resizeToAvoidBottomInset: true,
              extendBody: false,
              appBar: ProfileAppBar(
                  title: Text(
                args!.user.userName,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: mainBackgroundColor,
                    textBaseline: TextBaseline.alphabetic),
              )),
              body: ChangeNotifierProvider(
                  create: (BuildContext context) {
                    return ScrollsPreviewManager(
                        context: context, user: args.user);
                  },
                  child: const ProfileBodyWrapper()),
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}

class ProfileBodyWrapper extends StatelessWidget {
  const ProfileBodyWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollsPreviewManager>(
      builder: (context, provider, child) {
        return ProfileBody(user: provider.user, isSelf: provider.isUserSelf);
      },
    );
  }
}

class ProfileBody extends StatefulWidget {
  UserMin user;
  bool? isSelf = null;

  ProfileBody({super.key, required this.user, required this.isSelf});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with DragUpdatable<ProfileBody> {
  @override
  int _duration = 2;
  @override
  bool _load = false;

  @override
  void initState() {
    reload();
    super.initState();

    //_reload();
  }

  @override
  void reload() {
    // this should recieve all data from the server,
    // then refreshed all contents of the page
    setLoadingTrue();
    context.read<ScrollsPreviewManager>().updateUser().then((value) {
      updateCallback();
    });
  }

  @override
  Widget AnimatedLoader(BuildContext context) {
    return super.AnimatedLoader(context);
  }

  @override
  Widget child(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: mainScrollController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: scrollsBackgroundColor),
        child: Column(
          children: [
            AnimatedLoader(context),
            ProfilePageHeader(
              user: widget.user,
              isSelf: widget.isSelf,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
    Timer(const Duration(milliseconds: 200), () {
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
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: CategorySelect(
            categories: const ['Scrolls', 'Videos', 'Favorites'],
            onPressed: indexChange,
          ),
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: menuScrollController,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
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
                radius: 20),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 0),
            curve: Curves.ease,
            height: (currentIndex == 1) ? null : 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, left: 10, bottom: 0),
                  child: BoxContainer(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: autoRecorderGradient),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                "Auto Recordings",
                                style: GoogleFonts.quicksand(
                                    color: mainBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      backgroundColor: Colors.transparent,
                      radius: 10),
                ),
                BoxContainer(
                    context: context,
                    child: const ScrollsPreviewMenu(),
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: scrollsBackgroundColor,
                    radius: 20),
              ],
            ),
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
                radius: 20),
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

Future showProfileImage(UserMin user, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 10,
          height: 10,
          child: Hero(
            tag: 'profile_${user.userId}',
            child: Image.network(
              user.profileImagePath!,
              width: 10,
              height: 10,
              fit: BoxFit.scaleDown,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: mainBackgroundColor),
        );
      });
}

class ProfilePageHeader extends StatelessWidget {
  UserMin user;
  bool? isSelf = null;
  ProfilePageHeader({super.key, required this.user, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 10),
      height: 315,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              height: 120,
              width: 338,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 338 / 3,
                    alignment: Alignment.center,
                    child: Profile(
                      user: user,
                      size: 1,
                      onTap: () {
                        showProfileImage(user, context);
                      },
                    ),
                  ),
                  Container(
                    width: 338 / 3 * 2 - 10,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName,
                          style: TextStyle(
                              fontSize: 17,
                              color: mainBackgroundColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Stack(
                            alignment: Alignment.centerLeft,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.tagger == null
                                          ? 'loading tagger...'
                                          : user.tagger!,
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    /*
                                    Container(
                                      margin: EdgeInsets.only(left: 0),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.white54,
                                        size: 18,
                                      ),
                                    )
                                    */
                                  ],
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                ],
              ),
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
                radius: 10,
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
                        RelationsPageArguments arguments =
                            RelationsPageArguments(user: user);

                        Navigator.pushNamed(context, RelationsPage.routeName,
                            arguments: arguments);
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
          (isSelf == null)
              ? const Center(
                  child: CupertinoActivityIndicator(
                      color: mainSubThemeColor, radius: 10.0, animating: true))
              : ProfileButtonSets(user: user, isSelf: isSelf!)
        ],
      ),
    );
  }
}

class ProfileButtonSets extends StatelessWidget {
  ProfileButtonSets({super.key, required this.user, required this.isSelf});

  final UserMin user;
  bool isSelf;

  @override
  Widget build(BuildContext context) {
    if (isSelf) {
      return Container(
        width: 338,
        height: 80,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              onPressed: () {
                showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) {
                      return ProfileEditView(context);
                    });
              },
              width: 195,
              height: 38,
              radius: 10,
              color: Color.fromARGB(255, 217, 217, 217),
              content: Text(
                "Edit Profile",
                style: TextStyle(
                    color: scrollsBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            FlatButton(
              onPressed: () {},
              width: 130,
              height: 38,
              radius: 10,
              color: Color.fromARGB(255, 217, 217, 217),
              content: Text(
                "Tag User",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: scrollsBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    } else if (!isSelf) {
      return Container(
        width: 338,
        height: 80,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Follow action button
            ProfileFollowButton(
              user: user,
              onFollowCall: () async {
                return await SocialInteractionsAPI().followUser(user.userId);
              },
              onUnfollowCall: () async {
                return await SocialInteractionsAPI().unfollowUser(user.userId);
              },
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
              onPressed: () {
                pickVideo(context);
              },
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
      );
    }
    return const Center(
        child: CupertinoActivityIndicator(
            color: mainSubThemeColor, radius: 10.0, animating: true));
  }
}
