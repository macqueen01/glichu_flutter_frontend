// Test Converter should be only used during debug phase
// Converter is used to convert scrolls into mp4 file using ffmpeg in client-side
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/Recorder/indexTimestamp.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';

class Converter {
  Converter();

  Future<void> convertRemixToVideo(
      RemixModel remix, String outputFilePath) async {
    int index = 1;
    while (await File(outputFilePath).exists()) {
      outputFilePath =
          outputFilePath.split(".").first.split('(').first + "($index).mp4";
      index++;
    }

    String command = "";
    List<String> imagePaths = [];

    remix.scrolls.imagePath.listSync().forEach((element) {
      imagePaths.add(element.path);
    });

    imagePaths.sort((a, b) {
      final aFileName = a.split("/").last.split(".").first;
      final bFileName = b.split("/").last.split(".").first;
      return int.parse(aFileName).compareTo(int.parse(bFileName));
    });

    IndexTimestamp currentTimestamp = remix.timeline.first!;
    print(remix.timeline.getLength());

    final filesTxt = await getOrCreateFolder('ffmpegTemp');
    final file = await File('$filesTxt/file.txt').create(recursive: true);

    final sink = await file.openWrite();

    for (int i = 0; i < remix.timeline.getLength() - 1; i++) {
      String imagePath = imagePaths[currentTimestamp.index];
      double timeGap =
          (currentTimestamp.next! - currentTimestamp).inMilliseconds /
              1000.0; // Convert time gap from milliseconds to seconds

      sink.writeln('file \'${imagePath}\'');
      sink.writeln('duration ${timeGap}');
      currentTimestamp = currentTimestamp.next!;
    }

    await sink.close();
    command += " -f concat -safe 0 -i ${file.path} $outputFilePath";

    final log = File(
        '/Users/jaekim/projects/mockingjae2_mobile/lib/src/Recorder/ffmpeg.txt');

    FFmpegSession result = await FFmpegKit.execute(command);
    log.writeAsString((await result.getOutput())!);
    file.deleteSync();
  }
}
