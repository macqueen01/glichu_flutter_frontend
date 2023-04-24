import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_player/video_player.dart';

class MJVideoViewer extends StatelessWidget {
  const MJVideoViewer({super.key, required this.controller, this.child});

  final VideoEditorController controller;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.video.value.isPlaying) {
          controller.video.pause();
        } else {
          controller.video.play();
        }
      },
      child: Center(
        child: Stack(
          children: [
            AspectRatio(
                aspectRatio: controller.video.value.aspectRatio,
                child: BoxContainer(
                    context: context,
                    child: VideoPlayer(controller.video),
                    backgroundColor: Colors.transparent)),
            if (child != null)
              AspectRatio(
                aspectRatio: controller.video.value.aspectRatio,
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
