import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class Profile extends StatefulWidget {
  final Image image;
  final int size;

  const Profile({super.key, required this.image, this.size = 0});

  List<double> sizeConvert(int size) {
    switch (size) {
      case 0:
        return [53, 49, 46];

      case 1:
        return [80, 76, 71];

      default:
        return [53, 49, 46];
    }
  }

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // check if current route starts with '/profile'
        // if not, activate the following pushNamed
        Navigator.pushNamed(context, '/profile');
      },
      child: Container(
        width: widget.sizeConvert(widget.size)[0],
        height: widget.sizeConvert(widget.size)[0],
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, gradient: lensFlareGradient),
        child: Container(
          width: widget.sizeConvert(widget.size)[1],
          height: widget.sizeConvert(widget.size)[1],
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: mainBackgroundColor),
          child: Container(
              width: widget.sizeConvert(widget.size)[2],
              height: widget.sizeConvert(widget.size)[2],
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: mainBackgroundColor),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              child: widget.image),
        ),
      ),
    );
  }
}
