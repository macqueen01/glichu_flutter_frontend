// This creates an access class to Video files in local device under app directory

import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingjae2_mobile/src/FileManager/AbstractManager.dart';
import 'package:mockingjae2_mobile/src/FileManager/lowestActions.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';
import 'package:mockingjae2_mobile/src/models/Remix.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/ScrollsPreview.dart';

// ScrollsPreviewManager to be used under Profile page.
// Interacts as a state manager
class ScrollsPreviewManager extends ScrollsManager {
  List<ScrollsPreviewModel> _previewModelList = [];
  bool updateInProgress = false;

  ScrollsPreviewManager({required super.context});

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<ScrollsPreviewModel> get previewModelList =>
      UnmodifiableListView(_previewModelList);

  Future<void> update() async {
    // dummy updater
    updateInProgress = true;
    await dummyUpdate();
    updateInProgress = false;
    return null;
  }

  bool isEmpty() {
    return _previewModelList.isEmpty;
  }

  bool isUpdateInProgress() {
    return updateInProgress;
  }

  Future<File?> getScrollsPreviewFromCache(String scrollsName) async {
    if (!await isCached(scrollsName)) {
      return null;
    }

    Directory scrollsDirectory =
        getDirectory(Directory(await cachedPath), scrollsName)!;
    File thumbnail = getFile(scrollsDirectory,
        '1')!; // Thumbnail should be the first image of the scrolls

    notifyListeners();
    return thumbnail;
  }

  Future<void> dummyUpdate() async {
    File? dummyFile = await getScrollsPreviewFromCache('Scrolls1');

    if (dummyFile == null) {
      return null;
    }

    for (int i = 0; i < 1; i++) {
      _previewModelList.add(
          ScrollsPreviewModel(scrollsName: 'Scrolls1', previewFile: dummyFile));
    }
  }
}

class ScrollsIndexImageCache {
  // This struct class has internal use only in ScrollsManager
  // Tmages should only be accessed by this cache through ScrollsManager
  // Other memory caches should not be reproduced to take extra memory.
  bool isDiskCached = true;
  bool isMemoryCached = false;
  List<Image>? scrollsImages;
  ScrollsModel scrollsModel;
  List<Highlight>? highlights;

  ScrollsIndexImageCache({required this.scrollsModel}) {
    if (this.scrollsImages == null) {
      this.scrollsImages = [];
    }

    if (this.highlights == null) {
      this.highlights = [];
    }
  }

  bool hasHighlights() {
    if (highlights == null || highlights!.isEmpty) {
      return false;
    }
    return true;
  }

  void setDiskCache() {
    if (isDiskCached) {
      return null;
    }

    isDiskCached = true;
  }

  void setMemoryCache(List<Image> images) {
    if (isMemoryCached) {
      return null;
    }

    if (!isDiskCached) {
      throw Error();
    }

    scrollsImages = images;
    isMemoryCached = true;
  }

  Future<void> setAllAudios(Directory audioDirectory) async {
    if (isMemoryCached) {
      return null;
    }

    if (!isDiskCached) {
      throw Error();
    }

    scrollsModel.highlightIndexList.forEach((highlightIndex) async {
      Highlight highlight = Highlight(index: highlightIndex);
      await highlight.setAudio(audioDirectory);
    });
  }

  Highlight getHighlight(int index) {
    // returns error when called without highlights inside this.highlights
    if (!hasHighlights()) {
      throw Error();
    }

    // If index errors, calls the first highlight inside highlights
    Highlight selectedHighlight = highlights![0];

    highlights!.forEach((highlight) {
      if (highlight.index == index) {
        selectedHighlight = highlight;
      }
    });

    return selectedHighlight;
  }

  void removeDiskCache() {
    // removes cache from disk

    if (isMemoryCached) {
      removeMemoryCache();
    }

    if (!isDiskCached) {
      return null;
    }

    // Execute disk removal
    // Blah Blah...
    isDiskCached = false;
  }

  void removeMemoryCache() {
    if (!isMemoryCached || !isDiskCached) {
      return null;
    }

    scrollsImages!.clear();
    highlights!.clear();
    isMemoryCached = false;
  }
}

class ScrollsManager extends ChangeNotifier {
  List<ScrollsIndexImageCache> _scrollsCache = [];
  int currentIndex = 0;
  int indexBound =
      3; // Index bound (total range be [currentIndex - indexBound, currentIndex + indexBound])
  final BuildContext context;
  final Future<String> cachedPath = getOrCreateFolder('scrolls/cached');
  ScrollsContentFetcher? _scrollsFetcher;

  ScrollsIndexImageCache getScrollsCache(int index) {
    return _scrollsCache[index];
  }

  Future<ScrollsContentFetcher?> getScrollsFetcher() async {
    if (_scrollsFetcher == null) {
      _scrollsFetcher =
          ScrollsContentFetcher(baseDir: Directory(await cachedPath));
      await _scrollsFetcher!.init();
    }
    return _scrollsFetcher;
  }

  void setIndex(int index) {
    this.currentIndex = index;
    setCurrentCacheImages(this.currentIndex)
        // Notify when current image cache has been loaded
        .then((value) => notifyListeners());
  }

  bool isEmpty() {
    return _scrollsCache.isEmpty;
  }

  int memoryCacheTotalRange() {
    return 2 * indexBound + 1;
  }

  int? lastIndex() {
    if (isEmpty()) {
      return null;
    }
    return _scrollsCache.length - 1;
  }

  int num_scrolls() {
    return _scrollsCache.length;
  }

  void addScrollsCache(ScrollsIndexImageCache newCache) {
    _scrollsCache.add(newCache);
  }

  void addAllScrollsCache(List<ScrollsIndexImageCache> newCacheList) {
    newCacheList.forEach((element) {
      addScrollsCache(element);
    });
    // notify when all the scrolls caches have been added
    notifyListeners();
  }

  List<int> memoryCacheIndexRange() {
    // Asssumes length of the _scrollsCache is longer than 0
    // Used
    List<int> indexRange = [];
    if (isEmpty()) {
      return indexRange;
    }
    if (num_scrolls() <= memoryCacheTotalRange()) {
      int index = 0;
      _scrollsCache.forEach((element) {
        indexRange.add(index);
        index++;
      });
      return indexRange;
    } else if (currentIndex - indexBound < 0) {
      int index = 0;
      while (index <= memoryCacheTotalRange() - 1) {
        indexRange.add(index);
        index++;
      }
    } else if (currentIndex + indexBound > num_scrolls() - 1) {
      int index = lastIndex()! - memoryCacheTotalRange() + 1;
      while (index <= lastIndex()!) {
        indexRange.add(index);
        index++;
      }
    } else {
      for (int index = (currentIndex - indexBound);
          index <= (currentIndex + indexBound);
          index++) {
        indexRange.add(index);
      }
    }
    return indexRange;
  }

  List<ScrollsIndexImageCache> getScrollsWithInBound() {
    // Returns all ScrollsIndexImageCache in list that are inside the bound
    // Used to keep scrolls images (inside memory) only within this list.
    // Scrolls images cached in memory out of this list will be deleted by removeMemoryCacheOutOfBound.
    List<ScrollsIndexImageCache> scrollsList = [];

    if (isEmpty()) {
      return scrollsList;
    }

    memoryCacheIndexRange().forEach((index) {
      scrollsList.add(_scrollsCache[index]);
    });

    return scrollsList;
  }

  List<ScrollsIndexImageCache> getScrollsOutOfBound() {
    List<ScrollsIndexImageCache> scrollsList = [];

    if (isEmpty()) {
      return scrollsList;
    }

    List<ScrollsIndexImageCache> scrollsWithInBound = getScrollsWithInBound();

    for (var element in _scrollsCache) {
      if (!scrollsWithInBound.contains(element)) {
        scrollsList.add(element);
      }
    }

    return scrollsList;
  }

  void removeMemoryCacheOutOfBound() {
    for (var scrollsCache in getScrollsOutOfBound()) {
      if (scrollsCache.isMemoryCached) {
        scrollsCache.removeMemoryCache();
      }
    }
  }

  Future<void> setCurrentCacheImages(int index) async {
    ScrollsIndexImageCache currentCache = _scrollsCache[index];

    if (!currentCache.isMemoryCached) {
      currentCache.setMemoryCache(await getScrollsImageFromNetwork(
          currentCache.scrollsModel.scrollsName));
      await currentCache.setAllAudios(getDirectory(
          Directory(await cachedPath), currentCache.scrollsModel.scrollsName)!);
    }

    // Feed images of the scrolls and highlights within range into memory
    // Syncronous manner
    for (ScrollsIndexImageCache scrollsCache in getScrollsWithInBound()) {
      if (!scrollsCache.isMemoryCached) {
        getScrollsImageFromNetwork(scrollsCache.scrollsModel.scrollsName)
            .then((images) async {
          scrollsCache.setMemoryCache(images);
          // wait for audio loading since this won't take so long
          scrollsCache.setAllAudios(getDirectory(Directory(await cachedPath),
              scrollsCache.scrollsModel.scrollsName)!);
        });
      }
    }

    // Remove all images inside memory that are of scrolls out of bound
    removeMemoryCacheOutOfBound();

    // return currentCache.scrollsImages!;
  }

  Future<List<Image>> getScrollsImageFromCache(String scrollsName) async {
    List<Image> scrollsImages = [];
    bool isAndroid = Platform.isAndroid;

    if (!await isCached(scrollsName)) {
      return scrollsImages;
    }

    Directory scrollsWithAudioDirectory =
        getDirectory(Directory(await cachedPath), scrollsName)!;
    Directory scrollsDirectory =
        getDirectory(scrollsWithAudioDirectory, 'scrolls')!;
    List<String> cachedImagePaths = filePathList(scrollsDirectory);
    scrollsPathSort(cachedImagePaths);
    scrollsImages = await Future.wait(cachedImagePaths.map(
      (imagePath) async {
        return await loadImageToMemory(
            path: imagePath,
            height: MediaQuery.of(context).size.height,
            isAndroid: isAndroid);
      },
    ));
    return scrollsImages;
  }

  Future<List<Image>> getScrollsImageFromNetwork(String scrollsName,
      {void Function(dynamic arg)? callback}) async {
    // Passes scrollsImages to callback if one is given as an argument
    List<Image> scrollsImages = [];

    if (callback != null) {
      scrollsImages = await getScrollsImageFromCache(scrollsName);
      callback(scrollsImages);
      return scrollsImages;
    }

    if (await isCached(scrollsName)) {
      scrollsImages = await getScrollsImageFromCache(scrollsName);
    } else {
      await downloadScrolls(scrollsName);
      scrollsImages = await getScrollsImageFromCache(scrollsName);
    }
    return scrollsImages;
  }

  Future<void> downloadScrolls(String scrollsName) async {
    // need to convert scrollsName to id if fetching from network
    await (await getScrollsFetcher())!.fetch(scrollsName);
  }

  void scrollsPathSort(List<String> scrollsPaths) {
    return scrollsPaths.sort((a, b) {
      final aFileName = a.split("/").last.split(".").first;
      final bFileName = b.split("/").last.split(".").first;
      return int.parse(aFileName).compareTo(int.parse(bFileName));
    });
  }

  Future<bool> isCached(String scrollsName) async {
    bool cached = false;

    Directory cachedDir = Directory(await cachedPath);

    directoryPathList(cachedDir).forEach((element) {
      if (element.split('/').last == scrollsName) {
        cached = true;
      }
    });

    return cached;
  }

  ScrollsManager({required this.context}) {
    appDirectory().then(
      (value) async {
        @override
        final path = await getOrCreateFolder('${value.path}/scrolls');
        @override
        final directory = Directory(path);
      },
    );
  }
}
