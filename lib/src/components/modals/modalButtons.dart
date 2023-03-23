import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalForm.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

ModalButton SettingsButton = ModalButton(
    icon: const Icon(
      CupertinoIcons.gear_solid,
      size: 30,
      color: scrollsBackgroundColor,
    ),
    text: "settings",
    onPressed: () {});

ModalButton AgeAuthentication = ModalButton(
  icon: const Icon(
    CupertinoIcons.number_circle_fill,
    size: 30,
    color: scrollsBackgroundColor,
  ),
  text: "age authentication",
  onPressed: () {},
);
