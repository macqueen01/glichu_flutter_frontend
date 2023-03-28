import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';

void main() {
  test('Test ScrollsFetcher fetch', () async {
    // Create a temporary directory for testing
    final baseDir = await Directory.systemTemp.createTemp();
    final fetcher = ScrollsFetcher(baseDir: baseDir);

    // Fetch some test scrolls
    final scrollsId = '1';
    await fetcher.fetch(scrollsId);

    // Check that the files were downloaded correctly
    final fileNames = ['1.jpeg', '2.jpeg', '3.jpeg'];
    for (final fileName in fileNames) {
      final file = File('${baseDir.path}/$fileName');
      expect(await file.exists(), isTrue);
      expect(await file.readAsString(), equals('Test file contents\n'));
    }

    // Delete the temporary directory
    await baseDir.delete(recursive: true);
  });
}
