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
      expect(
        responseData.uploadUrl,
        'https://storage.googleapis.com/cb-uploads-staging/zcYSmqkyKqJH6Mez7WJAcuJ8?GoogleAccessId=cb-backend%40cinderblock-198615.iam.gserviceaccount.com&Expires=1560354389&Signature=gpuglU%2FIWlxwIfVGJC%2Fle5LxFOPZx%2FnCpcCFVJuRmXye9tX9T8a5hvj7j5ZVLUIoOmMGK8cu5ZIDc1Na08%2FXw0T%2BbCTRnBXIZ2fDTxzOrLQmMz1sfsGb4NGSRRrwaNNOKggU9sLpvrIWBLTNgijuyxScS%2FO90briiBDCtITlXf5Ogv%2BNIkypQV6dqYyR2661Jz0iy94LKFRIPjGsfJmLSroszgAaAqvyzRIf4JAmF0Lyq26oxqCtQpquZ5m7qh2xP7z5iC7KQKvzIPYX5yMQctMWAyd6w8Xwcl8S88vqO0ovTkWrTrZSCRdXinVaDwFFjFknT%2F4ymgf6KsLYN7nD2w%3D%3D',
      );
      expect(responseData.headers['Content-MD5'], 'BdXPe8f6bkr3J4PcnYgnxw==');
    }).whenComplete(stopServer);
  });
}
