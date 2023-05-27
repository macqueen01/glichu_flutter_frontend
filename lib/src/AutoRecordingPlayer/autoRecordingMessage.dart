import 'package:mockingjae2_mobile/src/models/User.dart';

class AutoRecordingMessage {
  late UserMin commenter;
  late UserMin commentee;
  late int remixId;
  late String message;

  AutoRecordingMessage(
      {required this.remixId,
      required this.commenter,
      required this.commentee});

  void updateMessage(String message) {
    this.message = message;
  }
  /*
  Future<bool> pushMessage() async {

  }
  */
}
