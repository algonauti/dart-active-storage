import 'dart:io';

import 'package:active_storage/active_storage.dart';
import 'package:active_storage/src/uploader.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('directUpload() returns expected response data', () {
    return startServer().then((_) {
      var uploader = Uploader('$serverUrl/direct-upload');
      return uploader.directUpload(DirectUploadRequest(
        fileName: 'sample',
        contentType: 'text/plain',
        byteSize: 123456789,
        checksum: 'rL0Y20zC+Fzt72VPzMSk2A==',
      ));
    }).then((DirectUploadResponse responseData) {
      expect(responseData.id, 153);
      expect(responseData.key, 'zcYSmqkyKqJH6Mez7WJAcuJ8');
      expect(
        responseData.signedId,
        'eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBWms9IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e9e436de22c082cd1142a42ea29daa7eaf5df97d',
      );
      expect(responseData.uploadUrl, '$serverUrl/file-upload');
      expect(responseData.headers['Content-MD5'], 'BdXPe8f6bkr3J4PcnYgnxw==');
    }).whenComplete(stopServer);
  });

  test('fileUpload() sends large file in chunks and notifies progress',
      () async {
    var file = File('test/large.jpg');
    int fileSize = await file.length();
    var progressPercents = List<double>();
    return startServer().then((_) {
      var uploader = Uploader('$serverUrl/direct-upload');
      return uploader.fileUpload(
        fileContents: file.openRead(),
        byteSize: fileSize,
        directUploadResponse: directUploadResponseSample,
        onProgress: (percent) => progressPercents.add(percent),
      );
    }).then((_) {
      expect(progressPercents.length > 10, isTrue);
      expect(progressPercents.last, 100.0);
    }).whenComplete(stopServer);
  });

  test('fileUpload() sends small file altogether and notifies progress once',
      () async {
    var file = File('test/small.pdf');
    int fileSize = await file.length();
    var progressPercents = List<double>();
    return startServer().then((_) {
      var uploader = Uploader('$serverUrl/direct-upload');
      return uploader.fileUpload(
        fileContents: file.openRead(),
        byteSize: fileSize,
        directUploadResponse: directUploadResponseSample,
        onProgress: (percent) => progressPercents.add(percent),
      );
    }).then((_) {
      expect(progressPercents.length == 1, isTrue);
      expect(progressPercents.first, 100.0);
    }).whenComplete(stopServer);
  });
}

DirectUploadResponse get directUploadResponseSample => DirectUploadResponse(
      id: 153,
      key: 'zcYSmqkyKqJH6Mez7WJAcuJ8',
      signedId: 'eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBWms9IiwiZXhwIjpudWxsL',
      uploadUrl: '$serverUrl/file-upload',
      headers: {'Content-MD5': 'BdXPe8f6bkr3J4PcnYgnxw=='},
    );
