import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';

import 'package:mockingjae2_mobile/src/controller/scrollControlers.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';

class ScrollsBodyView extends StatefulWidget {
  const ScrollsBodyView({super.key});

  @override
  State<ScrollsBodyView> createState() => _ScrollsBodyViewState();
}

class _ScrollsBodyViewState extends State<ScrollsBodyView> {
  List<Image> images = <Image>[];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadImages(
            '/Users/jaekim/projects/mockingjae2_mobile/sample_scrolls/scrolls1/',
            context)
        .then((value) {
      setState(() {
        this.images = value;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScrollsBodyView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: scrollsBackgroundColor,
        ),
        child: Center(
          child: JaeIcon(55, 55, mainBackgroundColor),
        ),
      );
    } else {
      return ScrollsListViewBuilder(
          [images, images, images, images, images], _scrollController, context);
    }
  }
}

Widget ScrollsListViewBuilder(List<List<Image>> scrollsList,
    ScrollController scrollController, BuildContext context) {
  return Flex(
    direction: Axis.vertical,
    children: [
      Expanded(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: scrollsList.length,
          itemBuilder: (context, index) {
            return Scrolls(
                images: scrollsList[index],
                parentScrollController: scrollController,
                index: index);
          },
        ),
      )
    ],
  );
}

class Scrolls extends StatefulWidget {
  final List<Image> images;
  final ScrollController parentScrollController;
  final int index;

  const Scrolls(
      {super.key,
      required this.images,
      required this.parentScrollController,
      required this.index});

  @override
  _ScrollsState createState() => _ScrollsState();
}

class _ScrollsState extends State<Scrolls> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  int currentIndex = 0;
  double scrollDelta = 0;
  double _height = 3000;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scrollController = ScrollController();
    _controller.addListener(() {
      setState(() {
        currentIndex = (_controller.value * widget.images.length).floor();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: scrollsBackgroundColor),
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            _controller.value = notification.metrics.pixels / (_height - 800);
            scrollDelta = notification.metrics.pixels;

            if (currentIndex / widget.images.length > 0.88) {
              widget.parentScrollController.animateTo(
                  (widget.index + 1) * MediaQuery.of(context).size.height,
                  duration: const Duration(milliseconds: 230),
                  curve: Curves.ease);
            }

            if (_controller.value < -0.05) {
              widget.parentScrollController.animateTo(0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInCubic);
            }

            return true;
          },
          child: RepaintBoundary(
            child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ScrollsScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: _height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(fit: StackFit.expand, children: [
                    Positioned(
                      top: scrollDelta,
                      child: GestureDetector(
                        onLongPressStart: (LongPressStartDetails detail) {
                          _scrollController.animateTo(_height,
                              duration: Duration(
                                  seconds: 5 -
                                      ((5 / _height) * scrollDelta).floor()),
                              curve: Curves.ease);
                        },
                        onLongPressEnd: (LongPressEndDetails detail) {
                          _scrollController.jumpTo(scrollDelta);
                        },
                        onDoubleTap: () {
                          _scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.ease);
                        },
                        onTertiaryTapDown: (TapDownDetails detail) {
                          widget.parentScrollController.animateTo(
                              (widget.index - 1) *
                                  MediaQuery.of(context).size.height,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInCubic);
                        },
                        /*
                        onScaleStart: (details) {
                          print('start');
                        },
                        onScaleEnd: (details) {
                          print('end');
                        },
                        */
                        child: BoxContainer(
                            context: context,
                            backgroundColor: scrollsBackgroundColor,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: [
                                widget.images[currentIndex],
                                // status bar
                                StatusBar(
                                    currentIndex: currentIndex, widget: widget),
                                // remix number
                                Positioned(
                                  right: 2.5,
                                  top: 15,
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.arrow_2_circlepath,
                                            size: 24,
                                            color: mainBackgroundColor,
                                          ),
                                          Text(
                                            "61",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: mainBackgroundColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 15,
                                  width: 250,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 53,
                                          height: 53,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: lensFlareGradient
                                          ),
                                          child: Container(
                                            width: 46,
                                            height: 46,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainBackgroundColor
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'assets/icons/dalli.jpg',
                                              width: 50,
                                              height: 50,
                                            )
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'sample_person',
                                              style: TextStyle(
                                                color: mainBackgroundColor,
                                                fontSize: 14
                                              ),
                                            ),
                                            
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Text(
                                              '7h ago',
                                              style: TextStyle(
                                                  color: mainBackgroundColor,
                                                  fontSize: 12
                                                ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  ]),
                )),
          )),
    );
  }
}

Future<List<Image>> _loadImages(String path, BuildContext context) async {
  Directory testDir =
      await _testImageLoader('newDir', 'sample_scrolls/scrolls1', 824);

  List<String> imageFiles = testDir
      .listSync()
      .whereType<File>()
      .cast<File>()
      .map((f) => f.path)
      .toList();

  imageFiles.sort((a, b) {
    final aFileName = a.split("/").last.split(".").first;
    final bFileName = b.split("/").last.split(".").first;
    return int.parse(aFileName).compareTo(int.parse(bFileName));
  });

  final images = await Future.wait(imageFiles.map(
    (imagePath) async {
      final data = await rootBundle.load(imagePath);
      return Image.memory(
        Uint8List.view(data.buffer),
        gaplessPlayback: true,
        fit: BoxFit.fitHeight,
        height: MediaQuery.of(context).size.height,
      );
    },
  ));

  return images;
}

Future<Directory> _testImageLoader(
    String newDir, String assetDir, int assetLength) async {
  String newFullDir = await getOrCreateFolder(newDir);

  for (int i = 1; i <= assetLength; i++) {
    String filePath = newFullDir + '/$i.jpeg';
    File imageFile = File(filePath);
    if (!await imageFile.exists()) {
      final data = await rootBundle.load('$assetDir/$i.jpeg');
      await imageFile.writeAsBytes(data.buffer.asUint8List());
    }
  }

  return Directory(newFullDir);
}
