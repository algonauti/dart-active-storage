import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

/// The current server instance.
HttpServer? _server;

/// The URL for the current server instance.
Uri get serverUrl => Uri.parse('http://localhost:${_server!.port}');

/// Starts a new HTTP server.
Future startServer() {
  return HttpServer.bind("localhost", 0).then((s) {
    _server = s;
    s.listen((request) {
      var method = request.method;
      var path = request.uri.path;
      var response = request.response;

      if (path == '/error') {
        response.statusCode = 400;
        response.contentLength = 0;
        response.close();
        return;
      }

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
            'url': '$serverUrl/file-upload',
            'headers': {'Content-MD5': 'BdXPe8f6bkr3J4PcnYgnxw=='}
          }
        };
        var body = json.encode(responseData);
        response.contentLength = body.length;
        response.write(body);
        response.close();
        return;
      }

      if (method == 'PUT' && path == '/file-upload') {
        ByteStream(request).toBytes().then((requestBodyBytes) {
          if (requestBodyBytes.isEmpty) {
            response.statusCode = 403;
          } else {
            response.statusCode = 200;
          }
          response.close();
        });
      }
    });
  });
}

/// Stops the current HTTP server.
void stopServer() {
  if (_server != null) {
    _server!.close();
    _server = null;
  }
}
