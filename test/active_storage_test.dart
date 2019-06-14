import "dart:io";

import 'package:active_storage/active_storage.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test(
      'upload() returns signedId in DirectUploadResponse and notifies progress',
      () {
    double progress;
    return startServer().then((_) {
      var activeStorage =
          ActiveStorage(directUploadURL: '$serverUrl/direct-upload');
      File file = File('test/sample.txt');
      return activeStorage.upload(
        fileName: 'sample',
        fileMimeType: 'text/plain',
        file: file,
        onProgress: (percent) => progress = percent,
      );
    }).then((DirectUploadResponse response) {
      expect(response, TypeMatcher<DirectUploadResponse>());
      expect(response.signedId, isNotEmpty);
      expect(progress, 100.0);
    }).whenComplete(stopServer);
  });
}
