import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/models/Scrolls.dart';
import 'package:mockingjae2_mobile/src/models/Statistics.dart';
import 'package:path_provider/path_provider.dart';

// Sample Statistics Model (for testing)

Statistics SampleStatistics =
    Statistics(likes: 23984, remixes: 124324, recorded: 1245235);

class ScrollsPreviewModel {
  ScrollsModel scrollsModel;
  Statistics? statistics;

  Statistics getStatistics() {
    if (this.statistics == null) {
      return SampleStatistics;
    } else {
      return this.statistics!;
    }
  }

  ScrollsPreviewModel({required this.scrollsModel, this.statistics = null}) {
    if (this.statistics == null) {
      this.statistics = SampleStatistics;
    }
  }
}
