import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/Providers/authenticationPageProvider.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:provider/provider.dart';

import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class TaggerEditPage extends StatefulWidget {
  const TaggerEditPage({super.key});

  static const routeName = '/taggerEdit';

  @override
  State<TaggerEditPage> createState() => _TaggerEditPageState();
}

class _TaggerEditPageState extends State<TaggerEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scrollsBackgroundColor,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          border: Border.all(color: Colors.transparent),
          middle: Text(
            'Edit Tagger',
            style: TextStyle(
                color: mainBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: CupertinoColors.destructiveRed,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        body: Expanded(
          child: Stack(children: [
            Positioned(
                bottom: 100,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Center(
                    child: Stack(clipBehavior: Clip.none, children: [
                      Text(
                        """Tag together""",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            color: mainBackgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Positioned(
                          right: -16,
                          top: -4,
                          child: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                CupertinoIcons.info_circle,
                                color: mainBackgroundColor,
                                size: 14,
                              )))
                    ]),
                  ),
                )),
            Center(
                child: RippleAnimation(
              child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scrollsBackgroundColor,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child:

                      /*
                  FutureBuilder(
                    future:
                        context.read<AuthenticationCenterProvider>().profileImage,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.file(snapshot.data as File,
                            fit: BoxFit.fill);
                      } else if (snapshot.data == null) {
                        return SvgPicture.asset(
                          'assets/icons/Me.svg',
                          width: 100,
                          height: 100,
                        );
                      } else {
                        return const CupertinoActivityIndicator(
                            color: mainSubThemeColor,
                            radius: 10.0,
                            animating: true);
                      }
                    },
                  )
                  */
                      SvgPicture.asset(
                    'assets/icons/Me.svg',
                    width: 100,
                    height: 100,
                  )),
              color: mainBackgroundColor,
              delay: const Duration(seconds: 1),
              repeat: true,
              minRadius: 75,
              ripplesCount: 2,
              duration: const Duration(seconds: 3),
            )),
          ]),
        ));
  }
}

Future<Widget> UserIdCheckInfoBox(BuildContext context) async {
  AuthenticationCenterProvider provider =
      context.read<AuthenticationCenterProvider>();

  bool inUse = await provider.isIdAlreadyInUse();

  List<bool> conditions = [
    provider.isEmptyId(),
    provider.isNotValidStringId(),
    await provider.isIdAlreadyInUse()
  ];

  List<String> messages = [
    "Check you have entered your ID",
    "ID must not contain any white space, #, -, or @",
    "ID is already in use"
  ];

  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < conditions.length; i++)
          if (conditions[i])
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                messages[i],
                style: TextStyle(
                    color: Color.fromARGB(255, 229, 65, 53),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
              ),
            ),
      ],
    ),
  );
}
