import 'dart:io';

// Packages imports

import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsPreviewWidgets.dart';
import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';

// Scrolls Button related local import

import 'ScrollsWidget/InteractionWidgets.dart';
import 'ScrollsWidget/ScrollsHeader.dart';

class ScrollsBodyView extends StatefulWidget {
  const ScrollsBodyView({super.key});

  @override
  State<ScrollsBodyView> createState() => _ScrollsBodyViewState();
}

class _ScrollsBodyViewState extends State<ScrollsBodyView>
    with DragUpdatable<ScrollsBodyView> {
  List<Image> images = <Image>[];
  Highlight? highlight;
  late MainScrollsController _scrollController;

  @override
  void initState() {
    _scrollController = MainScrollsController();
    _loadAudios('').then((audios) {
      setState(() {
        this.highlight = Highlight(
            index: 440,
            forwardAudioBuffer: audios[23],
            reverseAudioBuffer: audios[24]);
      });
    });
    _loadImages(
            '/Users/jaekim/projects/mockingjae2_mobile/sample_scrolls/scrolls1/',
            context)
        .then((value) {
      setState(() {
        this.images = value;
      });
      _scrollController.addIndecies([images, images, images, images, images]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty || highlight == null) {
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
          [images, images, images, images, images],
          [highlight!, highlight!, highlight!, highlight!, highlight!],
          _scrollController,
          context);
    }
  }
}

Widget ScrollsListViewBuilder(
    List<List<Image>> scrollsList,
    List<Highlight> highlights,
    MainScrollsController scrollController,
    BuildContext context) {
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
                highlight: highlights[index],
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
  final MainScrollsController parentScrollController;
  final int index;
  final int duration;
  final Highlight? highlight;

  const Scrolls(
      {super.key,
      required this.images,
      required this.parentScrollController,
      this.duration = 10,
      required this.index,
      this.highlight});

  @override
  _ScrollsState createState() => _ScrollsState();
}

class _ScrollsState extends State<Scrolls> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  int currentIndex = 0;
  double scrollDelta = 0;
  final double _height = 3000;
  // Each scroll has seperate audio player
  final AudioPlayer player = AudioPlayer();

  Future<void> playAudioFromMemory(Uint8List audioData) async {
    if (player.playing == true) {
      await player.stop();
    }

    await player.setAudioSource(BytesSource(audioData));
    await player.play();
  }

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
            var scrollDirection =
                _scrollController.position.userScrollDirection;
            /*
            if (currentIndex.remainder(15) == 0) {
              playAudioFromMemory(widget.audios[(currentIndex / 15).floor()]);
            }
            */

            //print(currentIndex);

            // highlight position audio play
            if (widget.highlight != null &&
                currentIndex - 10 <= widget.highlight!.index &&
                widget.highlight!.index <= currentIndex) {
              if (scrollDirection == ScrollDirection.forward) {
                playAudioFromMemory(widget.highlight!.forwardAudioBuffer);
              } else if (scrollDirection == ScrollDirection.reverse) {
                playAudioFromMemory(widget.highlight!.reverseAudioBuffer);
              } else {
                playAudioFromMemory(widget.highlight!.forwardAudioBuffer);
              }
            }

            if (currentIndex / widget.images.length > 0.88) {
              // snap to the next scrolls
              widget.parentScrollController.switchToNextScrolls(context);
              // reset the scrolls at start
              _scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            }

            if (notification.metrics.pixels < -20 && widget.index != 0) {
              widget.parentScrollController.switchToLastScrolls(context);
            }

            return true;
          },
          child: SingleChildScrollView(
              controller: _scrollController,
              physics: const DampedScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: _height,
                width: MediaQuery.of(context).size.width,
                child: Stack(fit: StackFit.expand, children: [
                  Positioned(
                    top: (scrollDelta >= 0) ? scrollDelta : 0,
                    child: GestureDetector(
                      onLongPressStart: (LongPressStartDetails detail) {
                        // this auto scrolls at velocity (_height / widget.duration)
                        // works alongside with onLongPressEnd
                        _scrollController.animateTo(_height,
                            duration: Duration(
                                seconds: widget.duration -
                                    ((widget.duration / _height) * scrollDelta)
                                        .floor()),
                            curve: Curves.ease);
                      },
                      onLongPressEnd: (LongPressEndDetails detail) {
                        // this auto scrolls at velocity (_height / widget.duration)
                        // works alongside with onLongPressStart
                        _scrollController.jumpTo(scrollDelta);
                      },
                      onDoubleTap: () {
                        // this animates back to beginning of the scrolls
                        _scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.ease);
                      },
                      child: BoxContainer(
                          context: context,
                          backgroundColor: scrollsBackgroundColor,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: ([
                              widget.images[currentIndex],
                              // status bar
                              StatusBar(
                                  currentIndex: currentIndex, widget: widget),
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
                            ]),
                          )),
                    ),
                  )
                ]),
              ))),
    );
  }
}

// buisness utilities

class BytesSource extends StreamAudioSource {
  final Uint8List _buffer;

  BytesSource(this._buffer) : super(tag: 'AudioSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Returning the stream audio response with the parameters
    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: (start ?? 0) - (end ?? _buffer.length),
      offset: start ?? 0,
      stream: Stream.fromIterable([_buffer.sublist(start ?? 0, end)]),
      contentType: 'audio/mpeg',
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

class Highlight {
  final int index;
  final Uint8List forwardAudioBuffer;
  final Uint8List reverseAudioBuffer;

  const Highlight({
    required this.index,
    required this.forwardAudioBuffer,
    required this.reverseAudioBuffer,
  });
}

Future<List<Uint8List>> _loadAudios(String path) async {
  Directory testDir =
      await _testAudioLoader('audioDirectory7', 'audios/audios7', 51);

  List<String> audioFiles = testDir
      .listSync()
      .whereType<File>()
      .cast<File>()
      .map((f) => f.path)
      .toList();

  audioFiles.sort((a, b) {
    final aFileName = a.split("/").last.split(".").first;
    final bFileName = b.split("/").last.split(".").first;
    return int.parse(aFileName).compareTo(int.parse(bFileName));
  });

  final audios = await Future.wait(audioFiles.map(
    (audioPath) async {
      final data = await rootBundle.load(audioPath);
      return Uint8List.view(data.buffer);
    },
  ));

  return audios;
}

Future<List<String>> _loadAudiosAsDir(String path) async {
  Directory testDir =
      await _testAudioLoader('audioDirectory7', 'audios/audios7', 51);

  List<String> audioFiles = testDir
      .listSync()
      .whereType<File>()
      .cast<File>()
      .map((f) => f.path)
      .toList();

  audioFiles.sort((a, b) {
    final aFileName = a.split("/").last.split(".").first;
    final bFileName = b.split("/").last.split(".").first;
    return int.parse(aFileName).compareTo(int.parse(bFileName));
  });

  final audios = await Future.wait(audioFiles.map(
    (audioPath) async {
      return audioPath;
    },
  ));

  return audios;
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

Future<Directory> _testAudioLoader(
    String newDir, String assetDir, int assetLength) async {
  String newFullDir = await getOrCreateFolder(newDir);

  for (int i = 1; i <= assetLength; i++) {
    String filePath = newFullDir + '/$i.mp3';
    File imageFile = File(filePath);
    if (!await imageFile.exists()) {
      final data = await rootBundle.load('$assetDir/$i.mp3');
      await imageFile.writeAsBytes(data.buffer.asUint8List());
    }
  }

  return Directory(newFullDir);
}
