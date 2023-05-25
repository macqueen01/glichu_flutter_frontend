import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsHeader.dart';
import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart';

class LikePageArguments {
  final User user;
  final List<User> likes;

  LikePageArguments({required this.user, required this.likes});
}

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  static const routeName = '/likes';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LikePageArguments;

    return Scaffold(
      backgroundColor: scrollsBackgroundColor,
      appBar: centeredTitleAppBar(
        // title should be a text base aligned richtext of user name and 's likes
        title: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                text: args.user.userId,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: mainBackgroundColor,
                    textBaseline: TextBaseline.ideographic),
                children: [
                  TextSpan(
                    text: "'s likes",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: mainBackgroundColor,
                        textBaseline: TextBaseline.ideographic),
                  )
                ])),
      ),
      body: LikesListBody(args: args),
    );
  }
}

// custom list tile with profile image and name
class LikeTile extends StatelessWidget {
  const LikeTile({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Profile(
            user: UserMin(
                userId: user.userId,
                userName: user.userName,
                profileImagePath: user.profileImagePath)),
        title: Text(
          user.userId,
          style: TextStyle(color: mainBackgroundColor),
        ),
        subtitle: Text(
          user.userName,
          style: TextStyle(color: Colors.white60),
        ),
        trailing: CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          child: BoxContainer(
              context: context,
              width: 65,
              height: 30,
              backgroundColor: Colors.white30,
              radius: 8,
              child: Text(
                "Follow",
                style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70),
                textAlign: TextAlign.center,
              )),
        ));
  }
}

class LikesListBody extends StatefulWidget {
  final LikePageArguments args;
  const LikesListBody({super.key, required this.args});

  @override
  State<LikesListBody> createState() => _LikesListBodyState();
}

class _LikesListBodyState extends State<LikesListBody>
    with DragUpdatable<LikesListBody> {
  @override
  int _duration = 2;

  @override
  void initState() {
    super.initState();
    //_reload();
  }

  @override
  Widget child(BuildContext context) {
    return ListView.separated(
      itemCount: widget.args.likes.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              AnimatedLoader(context),
              LikeTile(user: widget.args.likes[index])
            ],
          );
        } else {
          return LikeTile(user: widget.args.likes[index]);
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.white10,
          thickness: 1.4,
          indent: 38,
          endIndent: 38,
          height: 18,
        );
      },
    );
  }
}
