import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:video_player/video_player.dart';

class AutoRecordingController {
  late final VideoPlayerController videoController;
  late final RemixViewModel remixViewModel;
  late Duration totalDuration;
  late Duration chunkDuration;
  void Function()? callback;

  int fps;
  bool isFinished = true;
  bool forcedPause = false;

  AutoRecordingController(
      {required this.videoController,
      required this.remixViewModel,
      this.fps = 25,
      this.callback}) {
    totalDuration = videoController.value.duration;
    chunkDuration =
        Duration(milliseconds: (totalDuration.inMilliseconds / 25).floor());
    isFinished = true;
  }

  Future<void> init() async {
    await videoController.seekTo(Duration.zero);
    isFinished = true;
  }

  void play({bool loop = false, void Function()? playCallback}) async {
    IndexTimeLine? timeline = remixViewModel.timeline;
    isFinished = false;

    if (timeline == null || timeline.first == null) {
      isFinished = true;
      return null;
    }

    IndexTimestamp timestamp = timeline.first!;

    var paused = false;

    while (timestamp.next != null && !isForcedPaused() && !paused) {
      var index = timestamp.index;
      IndexTimestamp nextStamp = timestamp.next!;
      // x0.6 of original pase
      Duration timeDiff = (nextStamp - timestamp) * (5 / 3);

      try {
        await seekToIndex(index);
        await Future.delayed(timeDiff);
      } catch (e) {
        print(e);
        paused = true;
      }

      timestamp = nextStamp;
    }

    isFinished = true;

    if (loop == false) {
      _unsetForcedPause();
      if (callback != null) {
        callback!();
      }
      return;
    }

    return play(loop: loop);
  }

  void forcePause() {
    forcedPause = true;
  }

  void _unsetForcedPause() {
    forcedPause = false;
  }

  bool isForcedPaused() {
    return forcedPause;
  }

  Future<void> seekToIndex(int index) async {
    Duration eventTime =
        Duration(milliseconds: chunkDuration.inMilliseconds * index);

    if (eventTime > totalDuration || eventTime < Duration.zero) {
      return null;
    }

    await videoController.seekTo(eventTime);
    callback!();
  }
}
