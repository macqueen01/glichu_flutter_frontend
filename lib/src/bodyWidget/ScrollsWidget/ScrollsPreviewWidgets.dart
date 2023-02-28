import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';

import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/ScrollsPreview.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/profileScrolls.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:provider/provider.dart';

class ScrollsPreviewMenu extends StatefulWidget {
  const ScrollsPreviewMenu({super.key});

  @override
  State<ScrollsPreviewMenu> createState() => _ScrollsPreviewMenuState();
}

class _ScrollsPreviewMenuState extends State<ScrollsPreviewMenu> {
  @override
  void initState() {
    super.initState();
    context.read<ScrollsPreviewManager>().update();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollsPreviewManager>(
      builder: (context, scrollsPreviewManager, child) {
        if (scrollsPreviewManager.isUpdateInProgress()) {
          return Center(
            child: Text('Updating Scrolls',
                style: TextStyle(fontSize: 20, color: mainBackgroundColor)),
          );
        } else if (scrollsPreviewManager.isEmpty()) {
          return Center(
            child: Text('No Scrolls',
                style: TextStyle(fontSize: 20, color: mainBackgroundColor)),
          );
        }
        return ScrollsPreviewListBuilder(scrollsPreviewManager.previewModelList,
            MediaQuery.of(context).size.width / 2);
      },
    );
  }
}

Column ScrollsPreviewListBuilder(
    List<ScrollsPreviewModel> previewsList, double width) {
  return Column(
    children: [
      for (int i = 0; i < previewsList.length; i += 2)
        ScrollsPair(
          firstScrolls: ScrollsPreview(
              scrollsPreviewModel: previewsList[i], width: width),
          secondScrolls: (i + 1 < previewsList.length)
              ? ScrollsPreview(
                  scrollsPreviewModel: previewsList[i + 1], width: width)
              : null,
        ),
    ],
  );
}

Widget ScrollsPair({
  required ScrollsPreview firstScrolls,
  required ScrollsPreview? secondScrolls,
}) {
  if (secondScrolls == null) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        firstScrolls,
        Expanded(
          child: Container(
            width: firstScrolls.width - 2,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: const Center(
                child: Icon(
              CupertinoIcons.add,
              color: mainBackgroundColor,
              size: 45,
              weight: 200,
            )),
          ),
        )
      ],
    );
  }
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [firstScrolls, secondScrolls],
  );
}

class ScrollsPreview extends StatefulWidget {
  final ScrollsPreviewModel scrollsPreviewModel;
  final double width;

  const ScrollsPreview(
      {super.key, required this.scrollsPreviewModel, required this.width});

  @override
  State<ScrollsPreview> createState() => _ScrollsPreviewState();
}

class _ScrollsPreviewState extends State<ScrollsPreview> {
  bool _tapped = false;

  void _setFirstTap() {
    setState(() {
      _tapped = true;
    });
    Timer(const Duration(seconds: 6), _resetTap);
  }

  void _resetTap() {
    (mounted)
        ? setState(() {
            _tapped = false;
          })
        : null;
  }

  void _secondTap({required String scrollsName}) {
    // navigate to profile scrolls page
    Navigator.pushNamed(context, ProfileScrollsPage.routeName,
        arguments: ProfileScrollsPageArguments(
            user: User(
                userName: "JaeKim",
                userId: "mockingjae_^.^",
                followers: 35134,
                followed: 2344523,
                scrolled: 1235,
                likes: 45145,
                remixed: 54627),
            scrollsModels: []));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_tapped) {
          _setFirstTap();
        } else {
          _secondTap(scrollsName: widget.scrollsPreviewModel.scrollsName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: scrollsBackgroundColor, width: 1)),
        child: Stack(children: [
          // because we are animating the image opacity blending to
          // scrollsBackgroundColor, in white background, the icons (ScrollsInfoButton) might not visible
          AnimatedOpacity(
            opacity: _tapped ? 0.6 : 1,
            duration: const Duration(milliseconds: 100),
            child: Image.file(
              widget.scrollsPreviewModel.previewFile,
              fit: BoxFit.fitWidth,
              width: widget.width - 2,
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            width: 40,
            child: AnimatedOpacity(
              opacity: _tapped ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.arrow_2_circlepath,
                      statistic: widget.scrollsPreviewModel
                          .getStatistics()
                          .getRemixes()),
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.heart,
                      statistic: widget.scrollsPreviewModel
                          .getStatistics()
                          .getLikes()),
                  ScrollsInfoButton(
                      iconData: CupertinoIcons.videocam,
                      statistic: widget.scrollsPreviewModel
                          .getStatistics()
                          .getRecorded())
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
