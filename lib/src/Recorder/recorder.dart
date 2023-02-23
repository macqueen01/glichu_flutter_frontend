import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';

class Recorder {
  IndexTimeLine? timeline;
  Duration timeout;

  Recorder(
      // {required this.ScrollsModel,}
      {this.timeout = const Duration(seconds: 10)});

  void startRecording() {
    timeline = IndexTimeLine(timeout: timeout);
  }

  bool updateRecording(int index) {
    // returns false when called before startRecording

    if (timeline == null) {
      return false;
    }

    timeline!.createThenAdd(index);
    return true;
  }

  IndexTimeLine? stopRecording() {
    IndexTimeLine? tempTimeline = timeline;
    // flush the timeline and return it
    timeline = null;
    return tempTimeline;
  }
}
