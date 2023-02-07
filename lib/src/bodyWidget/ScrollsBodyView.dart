import 'dart:io';

// Packages imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollControlers.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';

// Scrolls Button related local import

import 'package:mockingjae2_mobile/src/components/buttons.dart';

import 'ScrollsWidget/InteractionWidgets.dart';
import 'ScrollsWidget/ScrollsHeader.dart';

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
  bool _overscroll = false;



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

              if (currentIndex / widget.images.length >= 0.88) {
                widget.parentScrollController.animateTo(
                    (widget.index + 1) * MediaQuery.of(context).size.height,
                    duration: const Duration(milliseconds: 230),
                    curve: Curves.ease);
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }

              if (notification.metrics.pixels < -30 && widget.index != 0) {
                widget.parentScrollController.animateTo(
                    (widget.index - 1) * MediaQuery.of(context).size.height,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
              }

              return true;
            },
            child: RepaintBoundary(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const DampedScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: _height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(fit: StackFit.expand, children: [
                      Positioned(
                        top: (scrollDelta > 0) ? scrollDelta : (-1 * scrollDelta),
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
                                      currentIndex: currentIndex,
                                      widget: widget),
                                  // remix number
                                  Positioned(
                                    right: 2.5,
                                    top: 20,
                                    child: ScrollsRelatedInfoButtonWrap(),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 15,
                                    width: 250,
                                    child: ScrollsHeader(),
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
