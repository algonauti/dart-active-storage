import "dart:io";

import 'package:active_storage/active_storage.dart';
import 'package:test/test.dart';

void main() {
  test('returns ActiveStorageBlob', () async {
    File file = File('test/sample.txt');
    int size = await file.length();
    int progress;
    var blob = await ActiveStorage.upload(
      fileName: 'sample',
      fileSize: size,
      fileMimeType: 'text/plain',
      fileContents: file.openRead(),
      directUploadURL: 'http://example.com/upload',
      onProgress: (percent) => progress = percent,
    );
    expect(blob, new TypeMatcher<DirectUploadResponse>());
    expect(progress, 100);
  });
}
