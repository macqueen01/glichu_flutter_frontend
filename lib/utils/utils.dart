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
        color: mainBackgroundColor, fontWeight: FontWeight.w400, fontSize: 16),
  );
}



