import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/VideoEditingPage.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:video_player/video_player.dart';

class AutoRecordingFullView extends StatelessWidget {
  late final VideoPlayer videoPlayer;
  late final String tag;
  AutoRecordingFullView(
      {super.key, required this.videoPlayer, required this.tag});

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      child: Hero(
        tag: tag,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double videoWidth =
              constraints.maxHeight * videoPlayer.controller.value.aspectRatio;
          return BoxContainer(
              context: context,
              width: videoWidth,
              height: constraints.maxHeight,
              child: videoPlayer);
        }),
      ),
    );
  }
}
