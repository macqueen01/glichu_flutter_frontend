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
}
