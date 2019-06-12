import "dart:io";

import 'package:active_storage/active_storage.dart';
import 'package:test/test.dart';

void main() {
  test('returns DirectUploadResponse', () async {
    var activeStorage =
        ActiveStorage(directUploadURL: 'http://example.com/upload');
    File file = File('test/sample.txt');
    int progress;
    var response = await activeStorage.upload(
      fileName: 'sample',
      fileMimeType: 'text/plain',
      file: file,
      onProgress: (percent) => progress = percent,
    );
    expect(response, new TypeMatcher<DirectUploadResponse>());
    expect(progress, 100);
  });
}
