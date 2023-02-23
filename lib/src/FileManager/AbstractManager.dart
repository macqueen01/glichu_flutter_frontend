import 'dart:io';

import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';

// This Abstract class provides basic functions for file management
// This class is not supposed to be used directly
// Consider this class as a template for other file management classes

abstract class Manager {
  late final String path;
  late final Directory directory;

  int totalFiles() {
    int numFiles = 0;

    directory.listSync().forEach(
      (element) {
        if (element.runtimeType == File) {
          numFiles++;
        }
      },
    );
    return numFiles;
  }

  int totalFolders() {
    int numFolders = 0;

    directory.listSync().forEach(
      (element) {
        if (element.runtimeType == Directory) {
          numFolders++;
        }
      },
    );
    return numFolders;
  }

  Future<File> getFileWithPath(String path) async {
    return File(path);
  }

  Future<File> getFileWithDirectory(String directory) async {
    return File(directory);
  }

  Future<List<File>> getAllFiles(List<String> paths) async {
    List<File> files = [];

    for (String path in paths) {
      files.add(await getFileWithPath(path));
    }

    return files;
  }

  Future<List<FileSystemEntity>> getDirectoryWithPath(String path) async {
    // Returns all detected files under the managing folder
    List<FileSystemEntity> detectedPaths = [];

    directory.listSync(recursive: true).forEach((element) {
      if (element.path.split('/').last == path.split('/').last) {
        detectedPaths.add(element);
      }
    });

    return detectedPaths;
  }

  Future<bool> isUnderThisManager(String path) async {
    // Shallow search for path... Should this path not given specific
    // e.g. path = 'videos'        --> ok
    //      path = 'videos/1.jpeg' --> bad
    //      path = '1.jpeg'        --> ok
    // might detect multiple names
    bool exists = false;
    directory.listSync(recursive: true).forEach((element) {
      if (element.path.split('/').last == path.split('/').last) {
        exists = true;
      }
    });
    return exists;
  }

  Manager() {
    appDirectory().then((value) {
      directory = value;
      path = value.path;
    });
  }
}
