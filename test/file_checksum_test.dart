import 'dart:io';

import 'package:active_storage/src/file_checksum.dart';
import 'package:test/test.dart';

void main() {
  test('returns md5 encoded as base64 string', () async {
    File file = File('test/sample.txt');
    String checksum = await FileChecksum.getMd5AsBase64(file: file);
    expect(checksum, 'rL0Y20zC+Fzt72VPzMSk2A==');
  });
}
