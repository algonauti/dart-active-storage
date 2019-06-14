import 'dart:io';

import 'package:active_storage/active_storage.dart';
import 'package:active_storage/src/uploader.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('directUpload()', () {
    test('returns expected response data', () {
      return startServer().then((_) {
        var uploader = Uploader('$serverUrl/direct-upload');
        return uploader.directUpload(directUploadRequestSample);
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

    test('throws HttpStatusException on server error', () {
      return startServer()
          .then((_) {
            var uploader = Uploader('$serverUrl/error');
            Future<DirectUploadResponse> result =
                uploader.directUpload(directUploadRequestSample);
            expect(result, throwsA(TypeMatcher<HttpStatusException>()));
            return result;
          })
          .catchError((_) {})
          .whenComplete(stopServer);
    });
  });

  group('directUpload()', () {
    test('sends large file in chunks and notifies progress', () async {
      var file = File('test/large.jpg');
      int fileSize = await file.length();
      var progressPercents = List<double>();
      return startServer().then((_) {
        var uploader = Uploader('$serverUrl/direct-upload');
        return uploader.fileUpload(
          fileContents: file.openRead(),
          byteSize: fileSize,
          directUploadResponse: correctDirectUploadResponse,
          onProgress: (percent) => progressPercents.add(percent),
        );
      }).then((_) {
        expect(progressPercents.length > 10, isTrue);
        expect(progressPercents.last, 100.0);
      }).whenComplete(stopServer);
    });

    test('sends small file altogether and notifies progress once', () async {
      var file = File('test/small.pdf');
      int fileSize = await file.length();
      var progressPercents = List<double>();
      return startServer().then((_) {
        var uploader = Uploader('$serverUrl/direct-upload');
        return uploader.fileUpload(
          fileContents: file.openRead(),
          byteSize: fileSize,
          directUploadResponse: correctDirectUploadResponse,
          onProgress: (percent) => progressPercents.add(percent),
        );
      }).then((_) {
        expect(progressPercents.length == 1, isTrue);
        expect(progressPercents.first, 100.0);
      }).whenComplete(stopServer);
    });

    test('throws HttpStatusException on server error', () async {
      var file = File('test/small.pdf');
      int fileSize = await file.length();
      return startServer()
          .then((_) {
            var uploader = Uploader('$serverUrl/direct-upload');
            Future<void> result = uploader.fileUpload(
              fileContents: file.openRead(),
              byteSize: fileSize,
              directUploadResponse: wrongDirectUploadResponse,
            );
            expect(result, throwsA(TypeMatcher<HttpStatusException>()));
            return result;
          })
          .catchError((_) {})
          .whenComplete(stopServer);
    });
  });
}

DirectUploadRequest get directUploadRequestSample => DirectUploadRequest(
      fileName: 'sample',
      contentType: 'text/plain',
      byteSize: 123456789,
      checksum: 'rL0Y20zC+Fzt72VPzMSk2A==',
    );

DirectUploadResponse get correctDirectUploadResponse => DirectUploadResponse(
      id: 153,
      key: 'zcYSmqkyKqJH6Mez7WJAcuJ8',
      signedId: 'eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBWms9IiwiZXhwIjpudWxsL',
      uploadUrl: '$serverUrl/file-upload',
      headers: {'Content-MD5': 'BdXPe8f6bkr3J4PcnYgnxw=='},
    );

DirectUploadResponse get wrongDirectUploadResponse => DirectUploadResponse(
      id: 153,
      key: 'zcYSmqkyKqJH6Mez7WJAcuJ8',
      signedId: 'eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBWms9IiwiZXhwIjpudWxsL',
      uploadUrl: '$serverUrl/error',
      headers: {'Content-MD5': 'BdXPe8f6bkr3J4PcnYgnxw=='},
    );
