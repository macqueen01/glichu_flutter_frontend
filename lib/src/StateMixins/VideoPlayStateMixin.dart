import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/FileManager/VideoManager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

mixin VideoPlayerMixin<T extends StatefulWidget> on State<T> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void videoControllerSetup(
      {required BuildContext context,
      File? videoFile,
      String? videoUrl,
      required ChangeNotifier manager}) {
    // Mendatory function for initializing video play view
    //manager.videoPlayerController = VideoPlayerController.file(videoFile);
    //controller = manager.videoPlayerController!;

    if (videoFile != null) {
      controller = VideoPlayerController.file(videoFile);
    } else if (videoUrl != null) {
      controller = VideoPlayerController.network(videoUrl);
    } else {
      controller = VideoPlayerController.network(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    }
    initializeVideoPlayerFuture = controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            controller.play();
            return Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 2 * controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                //FURTHER IMPLEMENTATION
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
