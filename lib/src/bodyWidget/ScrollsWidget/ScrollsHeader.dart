// Packages imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollControlers.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';

// Scrolls Button related local import

import 'package:mockingjae2_mobile/src/components/buttons.dart';





class ScrollsHeader extends StatelessWidget {
  const ScrollsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Profile(
            image: Image.asset(
              'assets/icons/dalli.jpg',
              width: 50,
              height: 50,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              idTextParser(id: 'mocking_jae_^.^', maxLength: 17),
              const SizedBox(
                height: 8,
              ),
              const Expanded(
                flex: 0,
                child: Text(
                  '7h ago',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainBackgroundColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Profile extends StatefulWidget {
  final Image image;

  const Profile({super.key, required this.image});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 53,
      height: 53,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, gradient: lensFlareGradient),
      child: Container(
        width: 49,
        height: 49,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: mainBackgroundColor),
        child: Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: mainBackgroundColor),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: widget.image),
      ),
    );
  }
}
