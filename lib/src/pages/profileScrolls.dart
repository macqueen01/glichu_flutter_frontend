// Scroll page only accessable through profile page

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/RemixBodyView.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/controller/scrollsControllers.dart';

import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

import 'package:provider/provider.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';

class ProfileScrollsPageArguments {
  final UserMin user;
  final List<ScrollsModel> scrollsModels;

  ProfileScrollsPageArguments(
      {required this.user, required this.scrollsModels});
}

class ProfileScrollsPage extends StatefulWidget {
  const ProfileScrollsPage({Key? key}) : super(key: key);

  static const routeName = '/profileScrolls';

  @override
  State<ProfileScrollsPage> createState() => _ProfileScrollsPageState();
}

class _ProfileScrollsPageState extends State<ProfileScrollsPage> {
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
    final args = ModalRoute.of(context)!.settings.arguments
        as ProfileScrollsPageArguments;
    return WillPopScope(
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return Scaffold(
              backgroundColor: scrollsBackgroundColor,
              resizeToAvoidBottomInset: true,
              extendBody: true,
              appBar: ProfileAppBar(
                  title: Text(
                args.user.userName,
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
                  child: SingleScrollsBodyView(
                    scrollsModels: args.scrollsModels,
                  )),
            );
          }),
          valueListenable: selectedIndex,
        ),
        onWillPop: () async {
          return false;
        });
  }
}

class SingleScrollsBodyView extends StatelessWidget {
  List<ScrollsModel> scrollsModels;

  SingleScrollsBodyView({super.key, required this.scrollsModels});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ScrollsManager(context: context)),
        ChangeNotifierProvider(create: (context) => RecordedVideoManager())
      ],
      child: SingleScrollsBody(
        scrollsModels: scrollsModels,
      ),
    );
  }
}

class SingleScrollsBody extends StatefulWidget {
  List<ScrollsModel> scrollsModels;

  SingleScrollsBody({super.key, required this.scrollsModels});

  @override
  State<SingleScrollsBody> createState() => _SingleScrollsBodyState();
}

class _SingleScrollsBodyState extends State<SingleScrollsBody>
    with DragUpdatable<SingleScrollsBody> {
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
    addAllScrolls(widget.scrollsModels);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
