import 'dart:async';
import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';

import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/ScrollsPreview.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/profileScrolls.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
        if (scrollsPreviewManager.updateInProgress) {
          return const ScrollsPreviewShimmerLoadingWidget();
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

class ScrollsPreviewShimmerLoadingWidget extends StatelessWidget {
  const ScrollsPreviewShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    double height = 1.5 * width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ShimmerLoadingWidget.Rectangular(height: height, width: width - 1),
            ShimmerLoadingWidget.Rectangular(height: height, width: width - 1)
          ],
        ),
        Container(
          height: 1,
          width: width * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ShimmerLoadingWidget.Rectangular(height: height, width: width - 1),
            ShimmerLoadingWidget.Rectangular(height: height, width: width - 1)
          ],
        ),
      ],
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

  void _secondTap() {
    // navigate to profile scrolls page
    ScrollsModel scrolls = widget.scrollsPreviewModel.scrollsModel;
    UserMin user = scrolls.user;

    ProfileScrollsPageArguments arguments =
        ProfileScrollsPageArguments(user: user, scrollsModels: [scrolls]);

    Navigator.pushNamed(context, ProfileScrollsPage.routeName,
        arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_tapped) {
          _setFirstTap();
        } else {
          _secondTap();
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
              child: Image.network(
                widget.scrollsPreviewModel.scrollsModel.thumbnailUrl,
                fit: BoxFit.fitWidth,
                width: widget.width - 2,
              )),
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
