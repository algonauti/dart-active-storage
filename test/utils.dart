import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// The current server instance.
HttpServer _server;

/// The URL for the current server instance.
Uri get serverUrl => Uri.parse('http://localhost:${_server.port}');

/// Starts a new HTTP server.
Future startServer() {
  return HttpServer.bind("localhost", 0).then((s) {
    _server = s;
    s.listen((request) {
      var method = request.method;
      var path = request.uri.path;
      var response = request.response;

      if (method == 'POST' && path == '/direct-upload') {
        response.statusCode = 200;
        response.headers.set('Content-Type', 'application/json; charset=utf-8');
        var responseData = {
          'id': 153,
          'key': 'zcYSmqkyKqJH6Mez7WJAcuJ8',
          'filename': 'avalon.jpg',
          'content_type': 'image/jpeg',
          'metadata': {},
          'byte_size': 88037,
          'checksum': 'BdXPe8f6bkr3J4PcnYgnxw==',
          'created_at': '2019-06-12T15:41:29.105Z',
          'signed_id':
              'eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBWms9IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e9e436de22c082cd1142a42ea29daa7eaf5df97d',
          'direct_upload': {
            'url':
                'https://storage.googleapis.com/cb-uploads-staging/zcYSmqkyKqJH6Mez7WJAcuJ8?GoogleAccessId=cb-backend%40cinderblock-198615.iam.gserviceaccount.com&Expires=1560354389&Signature=gpuglU%2FIWlxwIfVGJC%2Fle5LxFOPZx%2FnCpcCFVJuRmXye9tX9T8a5hvj7j5ZVLUIoOmMGK8cu5ZIDc1Na08%2FXw0T%2BbCTRnBXIZ2fDTxzOrLQmMz1sfsGb4NGSRRrwaNNOKggU9sLpvrIWBLTNgijuyxScS%2FO90briiBDCtITlXf5Ogv%2BNIkypQV6dqYyR2661Jz0iy94LKFRIPjGsfJmLSroszgAaAqvyzRIf4JAmF0Lyq26oxqCtQpquZ5m7qh2xP7z5iC7KQKvzIPYX5yMQctMWAyd6w8Xwcl8S88vqO0ovTkWrTrZSCRdXinVaDwFFjFknT%2F4ymgf6KsLYN7nD2w%3D%3D',
            'headers': {'Content-MD5': 'BdXPe8f6bkr3J4PcnYgnxw=='}
          }
        };
        var body = json.encode(responseData);
        response.contentLength = body.length;
        response.write(body);
        response.close();
        return;
      }
    });
  });
}

/// Stops the current HTTP server.
void stopServer() {
  if (_server != null) {
    _server.close();
    _server = null;
  }
}
