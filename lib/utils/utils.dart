import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

Future<String> getOrCreateFolder(String basename) async {
  // Get the directory where the app's documents are stored
  final Directory appDocDirectory = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  // Create a folder with the specified `basename` in the app's documents directory
  final Directory folder = Directory(appDocDirectory.path + '/$basename');

  // Check if the folder exists, if not, create it
  if (!await folder.exists()) {
    await folder.create();
  }

  return folder.path;
}

Text idTextParser({required String id, int maxLength = 20}) {
  if (id.length >= maxLength) {
    id = '${id.substring(0, 16)}...';
  }
  return Text(
    id,
    style: TextStyle(
        color: mainBackgroundColor,
        fontWeight: FontWeight.w400,
        fontSize: 14.5),
  );
}

String numberParser({required int number}) {
  if (number < 1100) {
    return '$number';
  }
  return (number / 1000).toStringAsFixed(1) + 'k';
}

double fontSizeParser({required int length}) {
  if (length <= 2) {
    return 15;
  } else if (length <= 4) {
    return 13;
  } else if (length <= 6) {
    return 12;
  }
  return 11;
}
