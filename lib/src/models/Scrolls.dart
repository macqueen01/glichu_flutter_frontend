import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/*

class Scrolls {
  const Scrolls({
    required String url,
    required String thumbnail,
    required 
  })
}
*/

class ScrollsModel {
  final Directory imagePath;
  final String scrollsName;
  final List<Image> imageList;

  const ScrollsModel(
      {required this.imagePath,
      required this.scrollsName,
      required this.imageList});
}
