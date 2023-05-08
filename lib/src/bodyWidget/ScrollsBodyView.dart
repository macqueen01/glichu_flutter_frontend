import 'dart:io';

// Packages imports

import 'package:audio_session/audio_session.dart';
import 'package:flutter/rendering.dart';

import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/GestureDetectViews/scrollWidget.dart';
import 'package:mockingjae2_mobile/src/Recorder/RecorderProvider.dart';
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/Recorder/recorder.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Restricted.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/StaticLoading.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';

import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/settings.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';
import 'package:mockingjae2_mobile/src/Recorder/testConverter.dart';
import 'package:provider/provider.dart';

// Scrolls Button related local import

import 'ScrollsWidget/InteractionWidgets.dart';
import 'ScrollsWidget/ScrollsHeader.dart';

class ScrollsBodyView extends StatelessWidget {
  const ScrollsBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ScrollsManager(context: context)),
        ChangeNotifierProvider(create: (context) => RecordedVideoManager())
      ],
      child: const ScrollsBody(),
    );
  }
}

class ScrollsBody extends StatefulWidget {
  const ScrollsBody({super.key});

  @override
  State<ScrollsBody> createState() => _ScrollsBodyState();
}

class _ScrollsBodyState extends State<ScrollsBody>
    with DragUpdatable<ScrollsBody> {
  late MainScrollsController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = MainScrollsController(
        onIndexChange: context.read<ScrollsManager>().setIndex);
    /*
    _loadAudios('').then((audios) {
      setState(() {
        this.highlight = Highlight(
            index: 440,
            forwardAudioBuffer: audios[23],
            reverseAudioBuffer: audios[24]);
      });
    });
    */
    _scrollController.setRefresh(_refresh);
    _refresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    // refreshes the page and adds scrolls model to the
    // page, appending at the bottom

    // This is dummy function that fetches scrolls from the server,
    // parses into scrolls model

    Future<List<ScrollsModel>> newModels({int num = 1}) async {
      List<ScrollsModel> dummyResult = [];

      ScrollsHeaderFetcher headerFetcher = ScrollsHeaderFetcher();

      for (int i = 0; i < num; i++) {
        // dummyResult.add(await _loadImages());
        ScrollsModel newModel = await headerFetcher.singleFetch();
        print(newModel.scrollsName);
        dummyResult.add(newModel);
      }
      return dummyResult;
    }

    List<ScrollsModel> toBeAdded = await newModels(num: 6);

    addAllScrolls(toBeAdded);
  }

  void addAllScrolls(List<ScrollsModel> scrollsModels) {
    // This is where ScrollsBodyView integrates ScrollsManager and ScrollsController
    List<ScrollsIndexImageCache> scrollsCaches = [];

    for (var scrollsModel in scrollsModels) {
      ScrollsIndexImageCache newCache =
          ScrollsIndexImageCache(scrollsModel: scrollsModel);
      scrollsCaches.add(newCache);
      // Adds index to scroll controller
      _scrollController.addIndex();
    }

    // adds all indicies to Scrolls Manager
    context.read<ScrollsManager>().addAllScrollsCache(scrollsCaches);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollsManager>(builder: (context, scrollsManager, child) {
      if (scrollsManager.isEmpty()) {
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
      }
      return ScrollsListViewBuilder(scrollController: _scrollController);
    });
  }
}

class ScrollsListViewBuilder extends StatefulWidget {
  final MainScrollsController scrollController;

  const ScrollsListViewBuilder({super.key, required this.scrollController});

  @override
  State<ScrollsListViewBuilder> createState() => _ScrollsListViewBuilderState();
}

class _ScrollsListViewBuilderState extends State<ScrollsListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.scrollController,
            scrollDirection: Axis.vertical,
            itemCount: context.read<ScrollsManager>().num_scrolls(),
            itemBuilder: (context, index) {
              return Scrolls(
                  // need to implement the highlight adding...
                  scrollsCache:
                      context.read<ScrollsManager>().getScrollsCache(index),
                  parentScrollController: widget.scrollController,
                  index: index);
            },
          ),
        )
      ],
    );
  }
}

class Scrolls extends StatefulWidget {
  final MainScrollsController parentScrollController;
  final int index;
  final int duration;
  final Highlight? highlight;
  final ScrollsIndexImageCache scrollsCache;

  const Scrolls(
      {super.key,
      required this.parentScrollController,
      this.duration = 10,
      required this.index,
      required this.scrollsCache,
      this.highlight});

  @override
  _ScrollsState createState() => _ScrollsState();
}

class _ScrollsState extends State<Scrolls> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SingleScrollsController _scrollController;
  int currentIndex = 0;
  double scrollDelta = 0;
  final double _height = 3000;
  // Each scroll has seperate audio player
  final AudioPlayer player = AudioPlayer();
  // Whether scrubbing has been recorded
  bool recording = false;
  Recorder recorder = Recorder();

  Future<void> playAudioFromMemory(Uint8List audioData) async {
    if (player.playing == true) {
      await player.stop();
    }

    await player.setAudioSource(BytesSource(audioData));
    await player.setAndroidAudioAttributes(AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
        flags: AndroidAudioFlags.none));

    await player.play();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scrollController =
        SingleScrollsController(height: _height, context: context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool scrollsIndexCheck(int index, length) {
    if (scrollsLowerBound(index) && scrollsUpperBound(index, length)) {
      return true;
    }
    return false;
  }

  bool scrollsLowerBound(int index) {
    if (0 <= index) {
      return true;
    }

    return false;
  }

  bool scrollsUpperBound(int index, int length) {
    if (index < length) {
      return true;
    }

    return false;
  }

  bool scrollsIndexChangeManager(
      ScrollNotification notification, List<Image> images) {
    // Buisness manager to scrolls item
    // this method manages actions related to image index changes
    // on scroll position change
    //
    // Consider this as a core functionality to the scrolls

    // defines scroll delta to use this metrix in dummy padding in
    // Stack-Position widget (Minor utility)
    scrollDelta = notification.metrics.pixels;

    // defines the _controller value by calculating current scroll position in percent
    _controller.value = 1 - _scrollController.remaining();

    // defines how image index is going to be displayed as in relationship to current scroll position
    int candidateIndex = (_controller.value * images.length).floor();
    if (!scrollsUpperBound(candidateIndex, images.length)) {
      // set index to image's last index if index exceeds upper bound
      currentIndex = images.length - 1;
    } else if (!scrollsLowerBound(candidateIndex)) {
      // set index to images's first index if index exceeds lower bound
      currentIndex = 0;
    } else {
      currentIndex = candidateIndex;
    }

    setState(() {
      candidateIndex = candidateIndex;
      scrollDelta = scrollDelta;
    });

    // Auto scroll position-time recording functionality
    // This should be imported from Recording Module

    if (!recording) {
      recorder.startRecording();
      recording = true;
    }

    recorder.updateRecording(currentIndex);

    // User Controlled Recording Unit
    // This interacts with RecorderProvider from main app runner

    RecorderProvider recorderProvider = context.read<RecorderProvider>();

    if (recorderProvider.isRecording) {
      recorderProvider.updateRecording(
          currentIndex, widget.scrollsCache.scrollsModel);
    }

    // Highlight position audio play
    // defines the scroll direction to play forward audio and backward audio in
    // according situation

    var scrollDirection = _scrollController.position.userScrollDirection;
    if (widget.scrollsCache.hasHighlights() &&
        currentIndex - 10 <= 440 &&
        440 <= currentIndex) {
      if (scrollDirection == ScrollDirection.forward) {
        playAudioFromMemory(
            widget.scrollsCache.getHighlight(440).forwardAudioBuffer!);
      } else if (scrollDirection == ScrollDirection.reverse) {
        playAudioFromMemory(
            widget.scrollsCache.getHighlight(440).reverseAudioBuffer!);
      } else {
        playAudioFromMemory(
            widget.scrollsCache.getHighlight(440).forwardAudioBuffer!);
      }
    }

    if (currentIndex / images.length > 0.96) {
      recording = false;
      IndexTimeLine recordedTimeline = recorder.stopRecording()!;

      if (recordedTimeline.last! - recordedTimeline.first! >
          const Duration(seconds: 2)) {
        // convert into remix
        RemixModel remix = RemixModel(
          'new',
          scrolls: widget.scrollsCache.scrollsModel,
          timeline: recordedTimeline,
        );

        context.read<RecordedVideoManager>().saveRemix(remix);
      }

      // User Controlled Recording Unit
      // This interacts with RecorderProvider from main app runner

      if (recorderProvider.isRecording) {
        // Pop up to query the name of the user recorded video

        recorderProvider.popUp(); // This gets info crutial for generated video
        recorderProvider.stopRecording();
        IndexTimeLine? userGeneratedTimeLine = recorderProvider.getTimeLine();

        if (userGeneratedTimeLine != null &&
            userGeneratedTimeLine.last! - userGeneratedTimeLine.first! >
                const Duration(milliseconds: 200)) {
          // convert into remix
          RemixModel remix = RemixModel(
            'new',
            scrolls: widget.scrollsCache.scrollsModel,
            timeline: userGeneratedTimeLine,
          );

          recorderProvider.saveRemix(remix);
        }
      }

      // snap to the next scrolls
      widget.parentScrollController.switchToNextScrolls(context);
      // reset the scrolls at start
      _scrollController.fastScrubToStart();
    }

    // Auto Recorder Unit

    if (notification.metrics.pixels <= -35 && widget.index != 0) {
      recording = false;
      IndexTimeLine recordedTimeline = recorder.stopRecording()!;

      if (recordedTimeline.last! - recordedTimeline.first! >
          const Duration(seconds: 2)) {
        String createdDate = DateTime.now().toString();
        ScrollsModel scrollsModel = widget.scrollsCache.scrollsModel;
        // convert into remix
        RemixModel remix = RemixModel(
          '${createdDate}_${scrollsModel.scrollsName}',
          scrolls: scrollsModel,
          timeline: recordedTimeline,
        );

        context.read<RecordedVideoManager>().saveRemix(remix);
      }

      // snap to the last scrolls if one exists
      widget.parentScrollController.switchToLastScrolls(context);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollsManager>(builder: (context, scrollsManager, child) {
      if (widget.index ==
              widget.parentScrollController.getCurrentScrollsIndex() &&
          widget.parentScrollController.isIndexChanged()) {
        scrollsManager.setIndex(widget.index);
      }
      if (!widget.scrollsCache.isMemoryCached ||
          widget.scrollsCache.scrollsImages == null) {
        return IndexChangeHandler(
          parentScrollController: widget.parentScrollController,
          index: widget.index,
          child: const LoadingView(),
        );
      }
      if (widget.scrollsCache.isMemoryCached &&
          widget.scrollsCache.scrollsModel.isRestricted) {
        return IndexChangeHandler(
          parentScrollController: widget.parentScrollController,
          index: widget.index,
          child: RestrictedView(),
        );
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: scrollsBackgroundColor),
        child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => scrollsIndexChangeManager(
                notification, widget.scrollsCache.scrollsImages!),
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
                        // this calls _scrollController.switchToNextScrolls() if swiped from right to left
                        onHorizontalDragEnd: (dragEndDetails) {
                          if (dragEndDetails.primaryVelocity! < 0) {
                            // Page forwards
                            widget.parentScrollController
                                .switchToNextScrolls(context);
                          } else if (dragEndDetails.primaryVelocity! > 0) {
                            // Page backwards
                            widget.parentScrollController
                                .switchToLastScrolls(context);
                          }
                        },

                        onLongPressStart: (LongPressStartDetails detail) {
                          // this auto scrolls at velocity (_height / widget.duration)
                          // works alongside with onLongPressEnd
                          _scrollController.scrubToEnd();
                        },
                        onLongPressEnd: (LongPressEndDetails detail) {
                          // this auto scrolls at velocity (_height / widget.duration)
                          // works alongside with onLongPressStart
                          _scrollController.scrubStop();
                        },
                        onDoubleTap: () {
                          // this animates back to beginning of the scrolls
                          _scrollController.fastScrubToStart();
                        },
                        onHorizontalDragStart: (details) {
                          // for test utilities only
                          // used only in test pipeline
                          widget.parentScrollController.refreshScroll();
                        },
                        child: BoxContainer(
                            context: context,
                            backgroundColor: scrollsBackgroundColor,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: ([
                                widget
                                    .scrollsCache.scrollsImages![currentIndex],
                                // status bar
                                StatusBar(
                                    currentIndex: currentIndex,
                                    length: widget
                                        .scrollsCache.scrollsImages!.length),
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
    });
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

Future<ScrollsModel> _loadImages() async {
  // Imagine a http call to server has been made to get the list of images
  // this will return a scrollsModel of the following:

  // Only under debugging!
  // This will pick random scrolls and display it

  String scrollsName = SampleScrolls().getSampleScrolls();

  ScrollsModel scrollsModel =
      ScrollsModel(scrollsName: scrollsName, highlightIndexList: [440]);

  return scrollsModel;
}

Future<List<Uint8List>> _loadAudios(String path) async {
  Directory testDir =
      await _testAudioLoader('audioDirectory', 'audios/audios7', 51);

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
      Uint8List data;
      data = await fileRead(audioPath);
      return Uint8List.view(data.buffer);
    },
  ));

  return audios;
}

Future<List<String>> _loadAudiosAsDir(String path) async {
  Directory testDir =
      await _testAudioLoader('audioDirectory', 'audios/audios7', 51);

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

// Test Loaders
// These loaders are only used for protyping and testing purposes

// Audio Loaders

Future<Directory> _testAudioLoader(
    String newDir, String assetDir, int assetLength) async {
  String newFullDir = await getOrCreateFolder(newDir);

  for (int i = 1; i <= assetLength; i++) {
    String filePath = newFullDir + '/$i.mp3';
    File audioFile = File(filePath);
    Uint8List data;
    if (!await audioFile.exists()) {
      data = await fileRead('$assetDir/$i.mp3');
      await audioFile.writeAsBytes(data.buffer.asUint8List());
    }
  }

  return Directory(newFullDir);
}
