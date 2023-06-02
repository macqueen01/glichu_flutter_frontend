import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';

import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/components/snackbars.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/mainPage.dart';
import 'package:mockingjae2_mobile/src/pages/Authentication/signUpView.dart';
import 'package:mockingjae2_mobile/src/pages/idEditPage.dart';
import 'package:mockingjae2_mobile/src/pages/taggerEditPage.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:provider/provider.dart';

Scaffold ProfileEditView(BuildContext context) {
  return Scaffold(
      backgroundColor: scrollsBackgroundColor,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: BigAppBar(
        preferredSize: const Size.fromHeight(250),
        backgroundColor: Colors.transparent,
        headerTextWidget: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EDIT YOUR',
                style: GoogleFonts.quicksand(
                    color: mainBackgroundColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 1),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "ONLY ",
                          style: GoogleFonts.quicksand(
                              color: mainBackgroundColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 1)),
                      TextSpan(
                          text: "PROFILE",
                          style: GoogleFonts.quicksand(
                              color: mainBackgroundColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1))
                    ]),
                  ))
            ],
          ),
        ),
        title: const Text(
          '',
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.w200,
              color: mainBackgroundColor,
              textBaseline: TextBaseline.alphabetic),
        ),
        onForwardButtonPressed: (BuildContext context) {},
        onBackButtonPressed: (BuildContext context) {
          Navigator.pop(context);
        },
        backButtonActivate: true,
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageChangeForm(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 60, right: 60),
            margin: EdgeInsets.only(top: 40),
            height: 50,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 100) / 3,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ID',
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, NameEditPage.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'jaekim',
                          style: GoogleFonts.quicksand(
                              color: mainBackgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                        CupertinoButton(
                            minSize: 20,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.chevron_right,
                              size: 20,
                              weight: 200,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, NameEditPage.routeName);
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 60, right: 60),
            margin: EdgeInsets.only(top: 0),
            height: 50,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 100) / 3,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tagger',
                    style: GoogleFonts.quicksand(
                        color: mainBackgroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, TaggerEditPage.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'mockingjae_root',
                          style: GoogleFonts.quicksand(
                              color: mainBackgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                        CupertinoButton(
                            minSize: 20,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.chevron_right,
                              size: 20,
                              weight: 200,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, TaggerEditPage.routeName);
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )));
}

class ProfileImageChangeForm extends StatefulWidget {
  const ProfileImageChangeForm({super.key});

  @override
  State<ProfileImageChangeForm> createState() => _ProfileImageChangeFormState();
}

class _ProfileImageChangeFormState extends State<ProfileImageChangeForm> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ImagePicker _picker = ImagePicker();
        XFile? _imageFile =
            await _picker.pickImage(source: ImageSource.gallery);
        /*
        context
            .read<AuthenticationCenterProvider>()
            .resetImage(File(_imageFile!.path));
        */
      },
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 150,
          clipBehavior: Clip.none,
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
                width: 150,
                height: 150,
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
            Positioned(
              right: -18,
              bottom: -18,
              child: CupertinoButton(
                onPressed: () async {
                  ImagePicker _picker = ImagePicker();
                  XFile? _imageFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  /*
                  context
                      .read<AuthenticationCenterProvider>()
                      .resetImage(File(_imageFile!.path));
                  */
                },
                child: Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    shape: BoxShape.circle,
                    gradient: minimizedWarmGradient,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: mainSubThemeColor,
                    size: 20,
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
