import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/main.dart';
import 'package:mockingjae2_mobile/src/AutoRecordingPlayer/controller.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/StateMixins/VideoPlayStateMixin.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Profiles.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AutoRecordingPopUpView extends StatefulWidget {
  final int scrollsId;
  const AutoRecordingPopUpView({super.key, required this.scrollsId});

  @override
  State<AutoRecordingPopUpView> createState() => _AutoRecordingPopUpViewState();
}

class _AutoRecordingPopUpViewState extends State<AutoRecordingPopUpView> {
  bool searchActivated = false;

  @override
  void initState() {
    super.initState();
  }

  void searchActivate() {
    setState(() {
      searchActivated = !searchActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      setState(() {
        searchActivated = false;
      });
    }

    return Material(
      color: scrollsBackgroundColor,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        height: MediaQuery.of(context).size.height * 0.8 +
            math.max(MediaQuery.of(context).viewInsets.bottom - 25, 0),
        child:
            Consumer<AutoRecordingPlayManager>(builder: (context, provider, _) {
          return Column(children: [
            Container(
              height: 60,
              //decoration: BoxDecoration(
              //    border: Border(
              //        bottom: BorderSide(
              //            color: Color.fromARGB(255, 91, 91, 91), width: 1.5))),
              child: Stack(children: [
                Positioned(
                    right: 20,
                    top: 28,
                    child: GestureDetector(
                      onTap: searchActivate,
                      child: searchActivated
                          ? Icon(
                              CupertinoIcons.xmark,
                              size: 23,
                              color: mainBackgroundColor,
                            )
                          : Icon(
                              CupertinoIcons.search,
                              size: 23,
                              color: mainBackgroundColor,
                            ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        alignment: Alignment.center,
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 91, 91, 91),
                          ),
                        ),
                      ),
                      Padding(
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
                                "Auto Recording",
                                style: GoogleFonts.quicksand(
                                    color: mainBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 50),
              opacity: searchActivated ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: searchActivated ? 60 : 0,
                width: MediaQuery.of(context).size.width,
                curve: standardEasing,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          // Default
                          provider.callByRecent(reset: true);
                        },
                        width: 50,
                        height: 30,
                        radius: 10,
                        content: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            "recent",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: mainBackgroundColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          // Call auto recordings that are scrolled the most
                          provider.callByMostScrolled(reset: true);
                        },
                        width: 100,
                        height: 30,
                        radius: 10,
                        content: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            "most scrolled",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: mainBackgroundColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          // Call auto recordings that are scrolled by acquaintances
                          provider.callByFollowers(reset: true);
                        },
                        width: 70,
                        height: 30,
                        radius: 10,
                        content: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            "followers",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: mainBackgroundColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: AutoRecordingMessagingMainView(
                    provider: provider, context: context)),
            AnimatedContainer(
                duration: Duration(milliseconds: 10),
                width: MediaQuery.of(context).size.width,
                height:
                    math.max(MediaQuery.of(context).viewInsets.bottom - 26, 0))
          ]);
        }),
      ),
    );
  }
}

Widget AutoRecordingMessagingMainView(
    {required AutoRecordingPlayManager provider,
    required BuildContext context}) {
  List<Widget> autoRecordingList = [];

  if (provider.isLoading && provider.length == 0) {
    return Container(
      height: 130,
      child: Center(
        child: const CupertinoActivityIndicator(
            color: mainSubThemeColor, radius: 10.0, animating: true),
      ),
    );
  } else if (provider.length == 0) {
    return Container(
      height: 130,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: Text(
            "No Auto Recording",
            style: GoogleFonts.quicksand(
                color: mainSubThemeColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  } else {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: TikTokStyleFullPageScroller(
              contentSize: provider.length,
              swipePositionThreshold: 0.2,
              swipeVelocityThreshold: 900,
              animationDuration: const Duration(milliseconds: 100),
              controller: provider.controller,
              builder: (BuildContext context, int index) {
                return AutoRecordingMessagingWidget(
                  remix: provider.getRemixViewModel(index),
                  manager: provider,
                  index: index,
                );
              },
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: AnimatedPadding(
                  duration: Duration(milliseconds: 50),
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).viewInsets.bottom > 40
                          ? 20
                          : 10)),
                  child: Container(
                    width: 340,
                    height: 42,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 0, left: 16, right: 16, top: 17),
                            child: TextField(
                              onChanged: (text) {
                                /*
                                provider.addMessage(
                                    text, , commentee);
                                    */
                              },
                              style: TextStyle(color: mainBackgroundColor),
                              decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: mainBackgroundColor),
                                  hintText: "your Impression",
                                  border: InputBorder.none),
                            ),
                          ),
                          width: 290,
                          height: 38,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 133, 133, 133)),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.arrow_up,
                            color: mainBackgroundColor,
                            size: 18,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: minimizedLensFlareGradient),
                        )
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}

class AutoRecordingMessagingWidget extends StatefulWidget {
  RemixViewModel remix;
  AutoRecordingPlayManager manager;
  int index = 0;

  AutoRecordingMessagingWidget(
      {super.key,
      required this.remix,
      required this.manager,
      required this.index});

  @override
  State<AutoRecordingMessagingWidget> createState() =>
      _AutoRecordingMessagingWidgetState();
}

class _AutoRecordingMessagingWidgetState
    extends State<AutoRecordingMessagingWidget>
    with VideoPlayerMixin<AutoRecordingMessagingWidget> {
  bool isPlaying = true;
  late AutoRecordingController autoRecordingController;
  late VideoPlayerController videoController;
  int playedAmount = 0;

  @override
  void initState() {
    videoControllerSetup(
        context: context,
        videoUrl: widget.remix.scrollsVideoUrl,
        manager: widget.manager);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget ExtendedBody;

    ExtendedBody = FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              widget.index == widget.manager.currentIndex) {
            autoRecordingController = AutoRecordingController(
                videoController: controller,
                remixViewModel: widget.remix,
                index: widget.index,
                manager: widget.manager,
                callback: () {
                  if (mounted) {
                    setState(() {});
                  }
                });
            if (!autoRecordingController.isPlaying && playedAmount == 0) {
              autoRecordingController.init().then((value) {
                autoRecordingController.play().then((value) {
                  playedAmount = 0;
                  if (mounted) {
                    setState(
                      () {
                        playedAmount = 0;
                        autoRecordingController.init();
                      },
                    );
                  }
                });
              });
              playedAmount++;
            }
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BoxContainer(
                    context: context,
                    width: 178,
                    height: 178 * 16 / 9,
                    child: VideoPlayer(autoRecordingController.videoController))
              ],
            );
          } else {
            return const Center(
                child: CupertinoActivityIndicator(
                    color: mainSubThemeColor, radius: 10.0, animating: true));
          }
        });

    return Container(
      height: MediaQuery.of(context).size.height * 0.7 - 60,
      width: MediaQuery.of(context).size.width,
      color: scrollsBackgroundColor,
      child: Row(
        children: [
          Expanded(child: ExtendedBody),
          Container(
            width: MediaQuery.of(context).size.width / 2.4,
            height: 310,
            child: Column(
              children: [
                Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width / 2.2,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Profile(
                          image: Image.network(widget.manager
                              .getRemixViewModel(widget.index)
                              .uploader
                              .profileImagePath!
                              .split('?')[0])),
                      Container(
                        height: 35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idTextParser(
                                id: widget.manager
                                    .getRemixViewModel(widget.index)
                                    .uploader
                                    .userName),
                            Text(
                              parseRelativeTime(widget.remix.createdAt),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainBackgroundColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
