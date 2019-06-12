import "dart:io";

import 'package:active_storage/active_storage.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('upload() returns DirectUploadResponse', () async {
    int progress;
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
      expect(response, new TypeMatcher<DirectUploadResponse>());
      expect(progress, 100);
    }).whenComplete(stopServer);
  });
}
