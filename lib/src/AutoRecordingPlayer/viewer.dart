import 'package:flutter/cupertino.dart';
import 'package:mockingjae2_mobile/src/AutoRecordingPlayer/controller.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:video_player/video_player.dart';

class AutoRecordingViewer extends StatefulWidget {
  int index;
  int currentIndex;
  VideoPlayerController videoController;
  AutoRecordingController autoRecordingController;

  AutoRecordingViewer(
      {super.key,
      required this.index,
      required this.currentIndex,
      required this.videoController,
      required this.autoRecordingController});

  @override
  State<AutoRecordingViewer> createState() => _AutoRecordingViewerState();
}

class _AutoRecordingViewerState extends State<AutoRecordingViewer> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = widget.videoController
      ..initialize().then((_) {
        print('here');
        setState() {
          print('gere');
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!videoController.value.isInitialized) {
      return Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        BoxContainer(
            context: context,
            width: 178,
            height: 178 * 16 / 9,
            child: VideoPlayer(widget.videoController..play()))
      ],
    );
  }
}
