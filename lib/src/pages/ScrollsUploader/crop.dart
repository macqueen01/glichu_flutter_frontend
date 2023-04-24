// Originally written by: @LeGoffMael
// Modified by: @macqueen01

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:mockingjae2_mobile/src/pages/ScrollsUploader/crop_mixin.dart';
import 'package:video_editor/domain/entities/transform_data.dart';
import 'package:video_editor/domain/helpers.dart';
import 'package:video_editor/ui/crop/crop_mixin.dart';
import 'package:video_editor/video_editor.dart';

class CropScreen extends StatelessWidget {
  const CropScreen({super.key, required this.controller});

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.left),
                  icon: const Icon(Icons.rotate_left),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.right),
                  icon: const Icon(Icons.rotate_right),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: CropGridViewer.edit(
                controller: controller,
                rotateCropArea: false,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 15),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "cancel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () =>
                                controller.preferredCropAspectRatio = controller
                                    .preferredCropAspectRatio
                                    ?.toFraction()
                                    .inverse()
                                    .toDouble(),
                            icon: controller.preferredCropAspectRatio != null &&
                                    controller.preferredCropAspectRatio! < 1
                                ? const Icon(
                                    Icons.panorama_vertical_select_rounded)
                                : const Icon(Icons.panorama_vertical_rounded),
                          ),
                          IconButton(
                            onPressed: () =>
                                controller.preferredCropAspectRatio = controller
                                    .preferredCropAspectRatio
                                    ?.toFraction()
                                    .inverse()
                                    .toDouble(),
                            icon: controller.preferredCropAspectRatio != null &&
                                    controller.preferredCropAspectRatio! > 1
                                ? const Icon(
                                    Icons.panorama_horizontal_select_rounded)
                                : const Icon(Icons.panorama_horizontal_rounded),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCropButton(context, null),
                          _buildCropButton(context, 1.toFraction()),
                          _buildCropButton(
                              context, Fraction.fromString("9/16")),
                          _buildCropButton(context, Fraction.fromString("3/4")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    // WAY 1: validate crop parameters set in the crop view
                    controller.applyCacheCrop();
                    // WAY 2: update manually with Offset values
                    // controller.updateCrop(const Offset(0.2, 0.2), const Offset(0.8, 0.8));
                    Navigator.pop(context);
                  },
                  icon: Center(
                    child: Text(
                      "done",
                      style: TextStyle(
                        color: const CropGridStyle().selectedBoundariesColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildCropButton(BuildContext context, Fraction? f) {
    if (controller.preferredCropAspectRatio != null &&
        controller.preferredCropAspectRatio! > 1) f = f?.inverse();

    return Flexible(
      child: TextButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: controller.preferredCropAspectRatio == f?.toDouble()
              ? Colors.grey.shade800
              : null,
          foregroundColor: controller.preferredCropAspectRatio == f?.toDouble()
              ? Colors.white
              : null,
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
        onPressed: () => controller.preferredCropAspectRatio = f?.toDouble(),
        child: Text(f == null ? 'free' : '${f.numerator}:${f.denominator}'),
      ),
    );
  }
}

class MJCropGridViewer extends CropGridViewer {
  MJCropGridViewer.preview({
    Key? key,
    required VideoEditorController controller,
  }) : super.preview(
          key: key,
          controller: controller,
        );

  MJCropGridViewer.edit({
    Key? key,
    required VideoEditorController controller,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 20),
    bool rotateCropArea = true,
  }) : super.edit(
          key: key,
          controller: controller,
          margin: margin,
          rotateCropArea: rotateCropArea,
        );

  @override
  _MJCropGridViewerState createState() => _MJCropGridViewerState();
}

class _MJCropGridViewerState extends State<CropGridViewer>
    with MJCropPreviewMixin {
  CropBoundaries _boundary = CropBoundaries.none;

  late VideoEditorController _controller;

  /// Minimum size of the cropped area
  late final double minRectSize = _controller.cropStyle.boundariesLength * 2;

  @override
  void initState() {
    _controller = widget.controller;
    _controller.addListener(widget.showGrid ? _updateRect : _scaleRect);
    if (widget.showGrid) {
      _controller.cacheMaxCrop = _controller.maxCrop;
      _controller.cacheMinCrop = _controller.minCrop;
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(widget.showGrid ? _updateRect : _scaleRect);
    super.dispose();
  }

  /// Returns the proper aspect ratio to apply depending on view rotation
  double? get aspectRatio => widget.rotateCropArea == false &&
          _controller.isRotated &&
          _controller.preferredCropAspectRatio != null
      ? getOppositeRatio(_controller.preferredCropAspectRatio!)
      : _controller.preferredCropAspectRatio;

  Size _computeLayout() => computeLayout(
        _controller,
        margin: widget.margin,
        shouldFlipped: _controller.isRotated && widget.showGrid,
      );

  /// Update crop [Rect] after change in [_controller] such as change of aspect ratio
  void _updateRect() {
    layout = _computeLayout();
    transform.value = TransformData.fromController(_controller);
    _calculatePreferedCrop();
  }

  /// Compute new [Rect] crop area depending of [_controller] data and layout size
  void _calculatePreferedCrop() {
    // set cached crop values to adjust it later
    Rect newRect = calculateCroppedRect(
      _controller,
      layout,
      min: _controller.cacheMinCrop,
      max: _controller.cacheMaxCrop,
    );
    if (_controller.preferredCropAspectRatio != null) {
      newRect = resizeCropToRatio(
        layout,
        newRect,
        widget.rotateCropArea == false && _controller.isRotated
            ? getOppositeRatio(_controller.preferredCropAspectRatio!)
            : _controller.preferredCropAspectRatio!,
      );
    }

    setState(() {
      rect.value = newRect;
      _onPanEnd(force: true);
    });
  }

  void _scaleRect() {
    layout = _computeLayout();
    rect.value = calculateCroppedRect(_controller, layout);
    transform.value =
        TransformData.fromRect(rect.value, layout, viewerSize, _controller);
  }

  /// Return [Rect] expanded position to improve touch detection
  Rect _expandedPosition(Offset position) =>
      Rect.fromCenter(center: position, width: 48, height: 48);

  /// Return expanded [Rect] to includes all corners [_expandedPosition]
  Rect _expandedRect() {
    final expandedPosition = _expandedPosition(rect.value.center);
    return Rect.fromCenter(
        center: rect.value.center,
        width: rect.value.width + expandedPosition.width,
        height: rect.value.height + expandedPosition.height);
  }

  /// Returns the [Offset] to shift [rect] with to centered in the view
  Offset get gestureOffset => Offset(
        (viewerSize.width / 2) - (layout.width / 2),
        (viewerSize.height / 2) - (layout.height / 2),
      );

  void _onPanDown(DragDownDetails details) {
    final Offset pos = details.localPosition - gestureOffset;
    _boundary = CropBoundaries.none;

    if (_expandedRect().contains(pos)) {
      _boundary = CropBoundaries.inside;

      // CORNERS
      if (_expandedPosition(rect.value.topLeft).contains(pos)) {
        _boundary = CropBoundaries.topLeft;
      } else if (_expandedPosition(rect.value.topRight).contains(pos)) {
        _boundary = CropBoundaries.topRight;
      } else if (_expandedPosition(rect.value.bottomRight).contains(pos)) {
        _boundary = CropBoundaries.bottomRight;
      } else if (_expandedPosition(rect.value.bottomLeft).contains(pos)) {
        _boundary = CropBoundaries.bottomLeft;
      } else if (_controller.preferredCropAspectRatio == null) {
        // CENTERS
        if (_expandedPosition(rect.value.centerLeft).contains(pos)) {
          _boundary = CropBoundaries.centerLeft;
        } else if (_expandedPosition(rect.value.topCenter).contains(pos)) {
          _boundary = CropBoundaries.topCenter;
        } else if (_expandedPosition(rect.value.centerRight).contains(pos)) {
          _boundary = CropBoundaries.centerRight;
        } else if (_expandedPosition(rect.value.bottomCenter).contains(pos)) {
          _boundary = CropBoundaries.bottomCenter;
        }
      }
      setState(() {}); // to update selected boundary color
      _controller.isCropping = true;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_boundary == CropBoundaries.none) return;
    final Offset delta = details.delta;

    switch (_boundary) {
      case CropBoundaries.inside:
        final Offset pos = rect.value.topLeft + delta;
        rect.value = Rect.fromLTWH(
            pos.dx.clamp(0, layout.width - rect.value.width),
            pos.dy.clamp(0, layout.height - rect.value.height),
            rect.value.width,
            rect.value.height);
        break;
      //CORNERS
      case CropBoundaries.topLeft:
        final Offset pos = rect.value.topLeft + delta;
        _changeRect(left: pos.dx, top: pos.dy);
        break;
      case CropBoundaries.topRight:
        final Offset pos = rect.value.topRight + delta;
        _changeRect(right: pos.dx, top: pos.dy);
        break;
      case CropBoundaries.bottomRight:
        final Offset pos = rect.value.bottomRight + delta;
        _changeRect(right: pos.dx, bottom: pos.dy);
        break;
      case CropBoundaries.bottomLeft:
        final Offset pos = rect.value.bottomLeft + delta;
        _changeRect(left: pos.dx, bottom: pos.dy);
        break;
      //CENTERS
      case CropBoundaries.topCenter:
        _changeRect(top: rect.value.top + delta.dy);
        break;
      case CropBoundaries.bottomCenter:
        _changeRect(bottom: rect.value.bottom + delta.dy);
        break;
      case CropBoundaries.centerLeft:
        _changeRect(left: rect.value.left + delta.dx);
        break;
      case CropBoundaries.centerRight:
        _changeRect(right: rect.value.right + delta.dx);
        break;
      case CropBoundaries.none:
        break;
    }
  }

  void _onPanEnd({bool force = false}) {
    if (_boundary != CropBoundaries.none || force) {
      final Rect r = rect.value;
      _controller.cacheMinCrop = Offset(
        r.left / layout.width,
        r.top / layout.height,
      );
      _controller.cacheMaxCrop = Offset(
        r.right / layout.width,
        r.bottom / layout.height,
      );
      _controller.isCropping = false;
      // to update selected boundary color
      setState(() => _boundary = CropBoundaries.none);
    }
  }

  //-----------//
  //RECT CHANGE//
  //-----------//

  /// Update [Rect] crop from incoming values, while respecting [_preferredCropAspectRatio]
  void _changeRect({double? left, double? top, double? right, double? bottom}) {
    top = max(0, top ?? rect.value.top);
    left = max(0, left ?? rect.value.left);
    right = min(layout.width, right ?? rect.value.right);
    bottom = min(layout.height, bottom ?? rect.value.bottom);

    // update crop height or width to adjust to the selected aspect ratio
    if (aspectRatio != null) {
      final width = right - left;
      final height = bottom - top;

      if (width / height > aspectRatio!) {
        switch (_boundary) {
          case CropBoundaries.topLeft:
          case CropBoundaries.bottomLeft:
            left = right - height * aspectRatio!;
            break;
          case CropBoundaries.topRight:
          case CropBoundaries.bottomRight:
            right = left + height * aspectRatio!;
            break;
          default:
            assert(false);
        }
      } else {
        switch (_boundary) {
          case CropBoundaries.topLeft:
          case CropBoundaries.topRight:
            top = bottom - width / aspectRatio!;
            break;
          case CropBoundaries.bottomLeft:
          case CropBoundaries.bottomRight:
            bottom = top + width / aspectRatio!;
            break;
          default:
            assert(false);
        }
      }
    }

    final newRect = Rect.fromLTRB(left, top, right, bottom);

    // don't apply changes if out of bounds
    if (newRect.width < minRectSize ||
        newRect.height < minRectSize ||
        !isRectContained(layout, newRect)) return;

    rect.value = newRect;
  }

  @override
  void updateRectFromBuild() {
    if (widget.showGrid) {
      // init the crop area with preferredCropAspectRatio
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateRect());
    } else {
      // init the widget with controller values if it is not the croping screen
      _scaleRect();
    }
  }

  @override
  Widget buildView(BuildContext context, TransformData transform) {
    // return crop view without the grid
    if (widget.showGrid == false) {
      return _buildCropView(transform);
    }

    // return the crop view with a [GestureDetector] on top to be able to edit the crop parameters
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCropView(transform),
        // for development only (rotation not applied)
        // Positioned.fromRect(
        //   rect: _expandedRect().shift(gestureOffset),
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       color: Colors.greenAccent.withOpacity(0.4),
        //     ),
        //   ),
        // ),
        Transform.rotate(
          angle: transform.rotation,
          child: GestureDetector(
            onPanDown: _onPanDown,
            onPanUpdate: _onPanUpdate,
            onPanEnd: (_) => _onPanEnd(),
            onTapUp: (_) => _onPanEnd(),
            child: const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    // color: Colors.redAccent.withOpacity(0.4), // dev only
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the [VideoViewer] tranformed with editing view
  /// Paint rect on top of the video area outside of the crop rect
  Widget _buildCropView(TransformData transform) {
    return Padding(
      padding: widget.margin,
      child: buildVideoView(
        _controller,
        transform,
        _boundary,
        showGrid: widget.showGrid,
      ),
    );
  }
}
