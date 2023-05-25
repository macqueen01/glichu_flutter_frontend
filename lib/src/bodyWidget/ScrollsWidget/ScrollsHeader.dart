// Packages imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/src/pages/profile.dart';

// Utility local imports

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:mockingjae2_mobile/utils/utils.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';

// Scroll Controller and Statusbar local import

import 'package:mockingjae2_mobile/src/controller/scrollPhysics.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/StatusBar.dart';

// Scrolls Button related local import

class ScrollsHeader extends StatelessWidget {
  UserMin user;
  String createdAt;

  ScrollsHeader({
    super.key,
    required this.user,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Profile(user: user),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    ProfilePageArguments arguments =
                        ProfilePageArguments(user: user);

                    Navigator.pushNamed(context, ProfilePage.routeName,
                        arguments: arguments);
                  },
                  child: idTextParser(id: user.userName, maxLength: 17)),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                flex: 0,
                child: Text(
                  parseRelativeTime(createdAt),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainBackgroundColor,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
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
  final UserMin user;
  final int size;
  final void Function()? onTap;
  Image? image;

  Profile({super.key, required this.user, this.size = 0, this.onTap = null}) {
    if (user.profileImagePath == null) {
      image = Image.asset(
        'assets/icons/dalli.jpg',
        width: 50,
        height: 50,
      );
    } else {
      image = Image.network(user.profileImagePath!,
          fit: BoxFit.fill, width: 100, height: 100);
    }
  }

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
    return Hero(
      tag: 'profile_${widget.user.userId}',
      child: GestureDetector(
        onTap: widget.onTap != null
            ? widget.onTap
            : () {
                ProfilePageArguments arguments =
                    ProfilePageArguments(user: widget.user);

                Navigator.pushNamed(context, ProfilePage.routeName,
                    arguments: arguments);
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
      ),
    );
  }
}
