import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';

// models
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';

class RemixModel {
  final IndexTimeLine timeline;
  final ScrollsModel scrolls;
  late String _title;
  String? _absolutePath;
  // final User jector;
  User? jector;

  void setPath(String absolutePath) {
    this._absolutePath = absolutePath;
  }

  String? getPath() {
    return this._absolutePath;
  }

  void setTitle(String newTitle) {
    _title = newTitle;
  }

  String getTitle() {
    return _title;
  }

  RemixModel(title,
      {required this.timeline, required this.scrolls, this.jector}) {
    this._title = title;
  }

  Map<String, dynamic> toJsonWithToken(String token) {
    return {
      'title': this._title,
      'timeline': this.timeline.toJson(),
      'scrolls': this.scrolls.scrollsName,
      'length': this.timeline.getLength(),
      'token': token
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this._title,
      'timeline': this.timeline.toJson(),
      'scrolls': this.scrolls.scrollsName,
      'length': 3000,
    };
  }
}

class RemixViewModel {
  late final int remixId;
  late final String remixTitle;
  late final String videoUrl;
  late final String thumbnailUrl;
  late final int scrollsId;
  late final UserMin uploader;
  late final AutoRecordingMessageModel? messageModel;

  RemixViewModel(
      {required this.remixId,
      required this.remixTitle,
      required this.videoUrl,
      required this.thumbnailUrl,
      required this.scrollsId,
      required this.uploader});

  RemixViewModel.fromMap(Map<String, dynamic> map) {
    this.remixId = map['id'];
    this.scrollsId = map['scrolls']['id'];
    this.uploader = UserMin.fromJson(map['user']);
    this.thumbnailUrl = map['thumbnail_url'];
    this.videoUrl = "https://mockingjae-test-bucket.s3.amazonaws.com/" +
        map['remix_directory'];
  }
}

class AutoRecordingMessageModel {
  late final String? textInput;

  AutoRecordingMessageModel();
}
