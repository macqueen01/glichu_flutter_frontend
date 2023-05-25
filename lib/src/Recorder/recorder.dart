import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/api/remix.dart';
import 'package:mockingjae2_mobile/src/db/TokenDB.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';

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

class SingletonRecorder {
  static SingletonRecorder instance = SingletonRecorder._init();
  static Recorder _recorder = Recorder();
  static AutoRecorderApi _autoRecorderApi = AutoRecorderApi();
  static bool _isRecording = false;
  static ScrollsModel? currentModel = null;

  SingletonRecorder._init();

  Recorder getRecorder() {
    return _recorder;
  }

  bool isRecording() {
    return _isRecording;
  }

  void startRecording(ScrollsModel scrolls) {
    if (_isRecording || _recorder.timeline != null || currentModel != null) {
      endRecording();
    }
    _isRecording = true;
    currentModel = scrolls;
    _recorder.startRecording();
  }

  void endRecording() {
    if (currentModel == null) {
      return null;
    }

    autoRecordingSave(currentModel!);
    currentModel = null;
    _isRecording = false;
  }

  void updateRecording(int index) {
    if (!_isRecording) {
      return;
    }

    _recorder.updateRecording(index);
  }

  void sendRemix(RemixModel remixModel, Future<String?> token) async {
    String? authToken = await token;

    if (authToken == null) {
      return;
    }

    _autoRecorderApi.uploadRemix(remixModel, authToken);
  }

  Future<void> autoRecordingSave(ScrollsModel scrollsModel) async {
    IndexTimeLine? recordedTimeline = _recorder.stopRecording();

    if (recordedTimeline == null) {
      return;
    }

    Duration totalDuration = recordedTimeline.last! - recordedTimeline.first!;
    Duration minDuration = const Duration(seconds: 2);
    Duration maxDuration = const Duration(seconds: 100);

    if (maxDuration > totalDuration && totalDuration > minDuration) {
      String createdDate = DateTime.now().toString(); // convert into remix
      RemixModel remix = RemixModel(
        '${'${'${createdDate}_${scrollsModel.scrollsName}'.hashCode + scrollsModel.hashCode}'.hashCode}' +
            '.mp4',
        scrolls: scrollsModel,
        timeline: recordedTimeline,
      );

      sendRemix(remix, TokenDatabase.instance.getToken());
    }
  }
}
