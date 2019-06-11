import "dart:io";

import 'package:active_storage/active_storage.dart';
import 'package:test/test.dart';

void main() {
  test('returns ActiveStorageBlob', () async {
    File file = File('test/sample.txt');
    int progress;
    var blob = await ActiveStorage.upload(
      fileName: 'sample',
      fileMimeType: 'text/plain',
      file: file,
      directUploadURL: 'http://example.com/upload',
      onProgress: (percent) => progress = percent,
    );
    expect(blob, new TypeMatcher<DirectUploadResponse>());
    expect(progress, 100);
  });
}
