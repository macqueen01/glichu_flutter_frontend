import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/LoginBodyView.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/RemixBodyView.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsBodyView.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsUploadView.dart';

const List<Widget> BodyWidgets = [
  LoginBodyView(),
  ScrollsBodyView(),
  ScrollsUploadView(),
  RemixBodyView()
];
