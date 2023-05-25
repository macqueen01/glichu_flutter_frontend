import 'dart:io';

// Packages imports

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/Recorder/recorder.dart';
import 'package:mockingjae2_mobile/src/StateMixins/VideoPlayStateMixin.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Restricted.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/StaticLoading.dart';

import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';

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
import 'package:video_player/video_player.dart';

// Scrolls Button related local import

import 'ScrollsWidget/InteractionWidgets.dart';
import 'ScrollsWidget/ScrollsHeader.dart';

class RemixBodyView extends StatelessWidget {
  const RemixBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RemixPlayManager())
      ],
      child: const RemixBody(),
    );
  }
}

class RemixBody extends StatefulWidget {
  const RemixBody({super.key});

  @override
  State<RemixBody> createState() => _RemixBodyState();
}

class _RemixBodyState extends State<RemixBody> with DragUpdatable<RemixBody> {
  // RemixBodyState shares the identical scroll controller ScrollsBodyView uses...
  late MainScrollsController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = MainScrollsController(
        onIndexChange: context.read<RemixPlayManager>().setIndex);
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

    Future<List<File>> newModels({int num = 1}) async {
      return await context.read<RemixPlayManager>().getAllRemixes();
    }

    List<File> toBeAdded = await newModels(num: 10);

    addAllScrolls(toBeAdded);
  }

  void addAllScrolls(List<File> remixFiles) {
    // This is where ScrollsBodyView integrates ScrollsManager and ScrollsController

    for (File remixFile in remixFiles) {
      // Adds index to scroll controller
      _scrollController.addIndex();
    }

    // adds all indicies to Scrolls Manager
    context.read<RemixPlayManager>().addAllRemixVideos(remixFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemixPlayManager>(builder: (context, remixManager, child) {
      if (remixManager.isEmpty()) {
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
      return RemixListViewBuilder(scrollController: _scrollController);
    });
  }
}

class RemixListViewBuilder extends StatefulWidget {
  final MainScrollsController scrollController;

  const RemixListViewBuilder({super.key, required this.scrollController});

  @override
  State<RemixListViewBuilder> createState() => _RemixListViewBuilderState();
}

class _RemixListViewBuilderState extends State<RemixListViewBuilder> {
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
            itemCount: context.read<RemixPlayManager>().num_scrolls(),
            itemBuilder: (context, index) {
              return IndexChangeHandler(
                parentScrollController: widget.scrollController,
                index: index,
                child: RemixPlayView(
                    index: index,
                    parentScrollController: widget.scrollController),
              );
            },
          ),
        )
      ],
    );
  }
}

class RemixPlayView extends StatefulWidget {
  final int index;
  final MainScrollsController parentScrollController;

  const RemixPlayView(
      {super.key, required this.index, required this.parentScrollController});

  @override
  State<RemixPlayView> createState() => _RemixPlayViewState();
}

class _RemixPlayViewState extends State<RemixPlayView>
    with VideoPlayerMixin<RemixPlayView> {
  bool isPlaying = false;

  @override
  void initState() {
    videoControllerSetup(
        context: context,
        videoFile: context.read<RemixPlayManager>().getRemix(widget.index),
        manager: context.read<RemixPlayManager>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemixPlayManager>(builder: (context, remixManager, child) {
      if (widget.index ==
              widget.parentScrollController.getCurrentScrollsIndex() &&
          widget.parentScrollController.isIndexChanged()) {
        remixManager.setIndex(widget.index);
      }
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: scrollsBackgroundColor),
          child: FutureBuilder(
              future: initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (isPlaying &&
                      widget.index !=
                          widget.parentScrollController
                              .getCurrentScrollsIndex()) {
                    controller.pause();
                    controller.seekTo(Duration.zero);
                    isPlaying = false;
                  }
                  if (widget.index ==
                      widget.parentScrollController.getCurrentScrollsIndex()) {
                    controller.play();
                    isPlaying = true;
                  }
                  return BoxContainer(
                      context: context,
                      backgroundColor: scrollsBackgroundColor,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SizedBox(
                        width: controller.value.aspectRatio *
                            MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height,
                        child: VideoPlayer(controller),
                      ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }));
    });
  }
}
