import 'dart:io';
import 'package:path_provider/path_provider.dart';


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





