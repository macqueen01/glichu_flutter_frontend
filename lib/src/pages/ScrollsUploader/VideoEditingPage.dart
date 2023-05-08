// Scroll page only accessable through profile page

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/FileManager/ScrollsManager.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/RemixBodyView.dart';

import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/ProcessingPage.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/crop.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/export_result.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/videoViewer.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

import 'package:provider/provider.dart';
import 'package:helpers/helpers.dart' show OpacityTransition;

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:video_editor/video_editor.dart';
import 'package:image_picker/image_picker.dart';

class ScrollsUploaderPageArguments {
  final User user;
  final File videoFile;

  ScrollsUploaderPageArguments({
    required this.user,
    required this.videoFile,
  });
}

/*

class ScrollsUploaderPage extends StatefulWidget {
  const ScrollsUploaderPage({Key? key}) : super(key: key);

  static const routeName = '/scrollsUploader';

  @override
  State<ScrollsUploaderPage> createState() => _ScrollsUploaderPageState();
}

class _VideoEditorExampleState extends State<VideoEditorExample> {
  final ImagePicker _picker = ImagePicker();

  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (mounted && file != null) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => VideoEditor(file: File(file.path)),
        ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image / Video Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Click on the button to select video"),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text("Pick Video From Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
*/

void pickVideo(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

  if (file != null) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            VideoEditingPage(file: File(file.path)),
      ),
    );
  }
}

class VideoEditingPage extends StatefulWidget {
  const VideoEditingPage({super.key, required this.file});

  final File file;

  static const routeName = '/videoEditor';

  @override
  State<VideoEditingPage> createState() => _VideoEditingPageState();
}

class _VideoEditingPageState extends State<VideoEditingPage> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 10),
  );
  late final ScrollsUploader uploader;

  bool _uploadFinished = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _exportCallback(File file) async {
    uploader = ScrollsUploader(currentLoadedVideo: file);
    bool task_done = false;

    try {
      await uploader.uploadVideoFile();
    } catch (e) {
      // Escape from the page if errors occur
      Navigator.pop(context);
    }

    while (task_done != true) {
      await Future.delayed(Duration(milliseconds: 1000), () async {
        task_done = await uploader.isTaskComplete(uploader.videoUploadTaskId);
      });
    }

    task_done = false;

    try {
      await uploader.scrollifyVideo(
          uploader.hashedVideoFile.toString(), 7000, 5, 25);
    } catch (e) {
      // Escape from the page if errors occur
      Navigator.pop(context);
    }

    while (task_done != true) {
      await Future.delayed(Duration(milliseconds: 1000), () async {
        task_done = await uploader.isTaskComplete(uploader.scrollifyTaskId);
      });
    }

    try {
      await uploader.uploadScrolls();
    } catch (e) {
      // Show Error Message
      print('failed uploading scrolls');
    }

    setState(() {
      _uploadFinished = true;
    });

    await Future.delayed(Duration(milliseconds: 6000), () {
      Navigator.pop(context);
    });
  }

  void _showErrorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );

  Future<void> _exportVideo() async {
    _exportingProgress.value = 0;
    _isExporting.value = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      // format: VideoExportFormat.gif,
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (stats, value) {
        _exportingProgress.value = value;
        setState(() {
          _loading = true;
        });
      },
      onError: (e, s) => _showErrorSnackBar("Error on export video :("),
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;

        /*
        showDialog(
          context: context,
          builder: (_) => VideoResultPopup(video: file),
        );
        */

        _exportCallback(file);
        // Then this should pass the file after the conversion.
      },
    );
  }

/*

  void _exportCover() async {
    await _controller.extractCover(
      onError: (e, s) => _showErrorSnackBar("Error on cover exportation :("),
      onCompleted: (cover) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => CoverResultPopup(cover: cover),
        );
      },
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: scrollsBackgroundColor,
        body: _controller.initialized & !_loading
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _topNavBar(),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          MJCropGridViewer.preview(
                                              controller: _controller),
                                          AnimatedBuilder(
                                            animation: _controller.video,
                                            builder: (_, __) =>
                                                OpacityTransition(
                                              visible: !_controller.isPlaying,
                                              child: GestureDetector(
                                                onTap: _controller.video.play,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: EdgeInsets.fromLTRB(
                                                      13, 0, 10, 0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    CupertinoIcons
                                                        .play_arrow_solid,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CoverViewer(controller: _controller)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _trimSlider(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*
                                ValueListenableBuilder(
                                  valueListenable: _isExporting,
                                  builder: (_, bool export, __) =>
                                      OpacityTransition(
                                    visible: export,
                                    child: AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      title: ValueListenableBuilder(
                                          valueListenable: _exportingProgress,
                                          builder: (_, double value, __) =>
                                              Container(
                                                width: 200,
                                                height: 20,
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  width: 200 * value,
                                                  height: 20,
                                                  color: mainBackgroundColor,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: mainBackgroundColor,
                                                  ),
                                                ),
                                              )),
                                    ),
                                  ),
                                ),
                                */
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: mainBackgroundColor,
              )),
      ),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  CupertinoIcons.left_chevron,
                  color: mainBackgroundColor,
                  size: 28,
                  weight: 600,
                ),
                tooltip: 'Leave editor',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(
                  CupertinoIcons.arrow_counterclockwise,
                  color: mainBackgroundColor,
                  size: 28,
                  weight: 600,
                ),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(
                  CupertinoIcons.arrow_clockwise,
                  color: mainBackgroundColor,
                  size: 28,
                  weight: 600,
                ),
                tooltip: 'Rotate clockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => CropScreen(controller: _controller),
                  ),
                ),
                icon: const Icon(
                  CupertinoIcons.crop,
                  color: mainBackgroundColor,
                  size: 28,
                  weight: 600,
                ),
                tooltip: 'Open crop screen',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () async {
                  _exportVideo();
                },
                icon: const Icon(
                  CupertinoIcons.chevron_right,
                  color: mainBackgroundColor,
                  size: 28,
                  weight: 600,
                ),
                tooltip: 'Process video',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final duration = _controller.videoDuration.inSeconds;
          final pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(
                formatter(Duration(seconds: pos.toInt())),
                style: GoogleFonts.quicksand(
                    color: mainBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              const Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    formatter(_controller.startTrim),
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatter(_controller.endTrim),
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        color: Colors.transparent,
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
            textStyle: GoogleFonts.quicksand(
                color: mainBackgroundColor,
                fontSize: 14,
                fontWeight: FontWeight.w300),
          ),
        ),
      )
    ];
  }
}

class ProcessLandingView extends StatefulWidget {
  final VideoEditorController controller;

  const ProcessLandingView({super.key, required this.controller});

  @override
  State<ProcessLandingView> createState() => _ProcessLandingViewState();
}

class _ProcessLandingViewState extends State<ProcessLandingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: MJVideoViewer(
                controller: widget.controller,
              ),
            ),
            const Text(
              'Processing',
              style: TextStyle(
                color: mainBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
