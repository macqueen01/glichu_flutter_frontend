import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

Widget ScrollsPair({
  required Hero firstScrolls,
  required Hero secondScrolls,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [firstScrolls, secondScrolls],
  );
}

class ScrollsPreview extends StatefulWidget {
  final String sampleSrc;
  final double width;

  const ScrollsPreview({super.key, required this.sampleSrc, required this.width});

  @override
  State<ScrollsPreview> createState() => _ScrollsPreviewState();
}

class _ScrollsPreviewState extends State<ScrollsPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: scrollsBackgroundColor, width: 1)),
      child: Image.asset(
        widget.sampleSrc,
        fit: BoxFit.fitWidth,
        width: widget.width - 2,
      ),
    );
  }
}