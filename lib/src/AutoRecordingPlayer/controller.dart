import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:video_player/video_player.dart';

class AutoRecordingController {
  late final VideoPlayerController videoController;
  late final RemixViewModel remixViewModel;
  late Duration totalDuration;
  late Duration chunkDuration;
  void Function()? callback;
  int index;
  AutoRecordingPlayManager manager;

  bool turn_off = false;

  int fps;
  bool isPlaying = false;
  bool forcedPause = false;

  AutoRecordingController(
      {required this.videoController,
      required this.remixViewModel,
      required this.index,
      required this.manager,
      this.fps = 25,
      this.callback}) {
    totalDuration = videoController.value.duration;
    chunkDuration =
        Duration(milliseconds: (totalDuration.inMilliseconds / 65).floor());
    isPlaying = false;
  }

  Future<void> init() async {
    await videoController.seekTo(Duration.zero);
    isPlaying = false;
  }

  Future<void> play({bool loop = false, void Function()? playCallback}) async {
    IndexTimeLine? timeline = remixViewModel.timeline;
    isPlaying = true;

    if (timeline == null || timeline.first == null) {
      isPlaying = false;
      return null;
    }

    IndexTimestamp timestamp = timeline.first!;

    var paused = false;

    while (
        timestamp.next != null && !paused && (manager.currentIndex == index)) {
      var index = timestamp.index;
      IndexTimestamp nextStamp = timestamp.next!;
      // x0.6 of original pase
      Duration timeDiff = (nextStamp - timestamp);

      try {
        await seekToIndex(index);
        await Future.delayed(timeDiff);
      } catch (e) {
        print(e);
        paused = true;
      }

      timestamp = nextStamp;
    }

    isPlaying = false;

    if (loop == false) {
      _unsetForcedPause();
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
      await videoController.seekTo(totalDuration);
      return null;
    }

    await videoController.seekTo(eventTime);
    callback!();
  }
}
