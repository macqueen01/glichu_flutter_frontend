import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

Future<Directory> appDirectory() async {
  final Directory appDocDirectory = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  return appDocDirectory;
}

Future<Directory> basenameToAppDirectory(String basename) async {
  // Get the directory where the app's documents are stored
  final Directory appDocDirectory = await appDirectory();
  // Create a folder with the specified `basename` in the app's documents directory
  final Directory folder = Directory('${appDocDirectory.path}/$basename');
  return folder;
}

Future<bool> fileExists(String basename) async {
  final folder = await basenameToAppDirectory(basename);
  return await folder.exists();
}

Future<String> getOrCreateFolder(String basename) async {
  final Directory folder = await basenameToAppDirectory(basename);

  // Check if the folder exists, if not, create it
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  return folder.path;
}

Future<Directory?> getFolderDirectory(String basename) async {
  // Get the directory where the app's documents are stored
  final Directory appDocDirectory = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  // Create a folder with the specified `basename` in the app's documents directory
  final Directory folder = Directory('${appDocDirectory.path}/$basename');

  // Check if the folder exists, if not, create it
  if (!await folder.exists()) {
    return null;
  }

  return folder;
}

Future<String> resolveFilePath(path) async {
  int index = 1;
  String parent = Directory(path).parent.path;
  String extension = fileExtension(File(path));
  while (await File(path).exists()) {
    // Continuously add index if there is a file the with same name exists
    path = '${parent + '/' + path.split('/').last // basename
        .split('.').first // filename without extension if one exists
        .split('(').first}($index).$extension'; // add extension
    index++;
  }
  return path;
}

Future<String> resolveDirectoryPath(path) async {
  int index = 1;
  String parent = Directory(path).parent.path;
  while (await Directory(path).exists()) {
    path = path.split('/').last.split('(').first + '($index)';
    index++;
  }
  return '$parent/$path';
}

Future<Image> loadImageToMemory(
    {isAndroid = false, height = 300, required path}) async {
  Uint8List data = await fileRead(path);

  return Image.memory(
    data,
    gaplessPlayback: true,
    fit: BoxFit.fitHeight,
    height: height,
  );
}

Future<Uint8List> fileRead(String path) async {
  Uint8List data;

  if (Platform.isAndroid) {
    data = (await File(path).readAsBytes());
  } else {
    data = Uint8List.view((await rootBundle.load(path)).buffer);
  }

  return data;
}

List<String> filePathList(Directory entry) {
  return entry
      .listSync()
      .whereType<File>()
      .cast<File>()
      .map((f) => f.path)
      .toList();
}

List<String> directoryPathList(Directory entry) {
  return entry
      .listSync()
      .whereType<Directory>()
      .cast<Directory>()
      .map((f) => f.path)
      .toList();
}

List<Directory> directoryList(Directory directory) {
  return directory
      .listSync(recursive: false)
      .whereType<Directory>()
      .cast<Directory>()
      .toList();
}

List<File> fileList(Directory directory) {
  return directory
      .listSync(recursive: false)
      .whereType<File>()
      .cast<File>()
      .toList();
}

Directory? getDirectory(Directory parent, String basename) {
  Directory? returnDirectory;

  directoryList(parent).forEach((element) {
    if (element.path.split('/').last == basename) {
      returnDirectory = element;
    }
  });

  return returnDirectory;
}

File? getFile(Directory parent, String basename) {
  String basenameWithoutExtension = basename.split('/').last.split('.').first;
  File? returnFile;

  fileList(parent).forEach((element) {
    if (element.path.split('/').last.split('.').first ==
        basenameWithoutExtension) {
      returnFile = element;
    }
  });

  return returnFile;
}

String fileExtension(File file) {
  String path = file.path;
  if (!path.split('/').last.contains('.')) {
    return '';
  }

  return path.split('/').last.split('.').last;
}
