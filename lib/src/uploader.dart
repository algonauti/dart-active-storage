import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'direct_upload.dart';

typedef ProgressCallback = void Function(int progressPercent);

class Uploader {
  final String directUploadURL;
  var headers = Map<String, String>();

  Uploader(this.directUploadURL);

  Future<DirectUploadResponse> directUpload(
      DirectUploadRequest requestData) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      // TODO maybe more?
    };
    requestHeaders.addAll(headers);
    http.Response response = await http.post(
      directUploadURL,
      headers: requestHeaders,
      body: requestData.toJson(),
    );
    String responseBody = _checkAndDecode(response);
    return DirectUploadResponse.fromJson(responseBody);
  }

  Future<void> fileUpload({
    @required Stream<List<int>> fileContents,
    @required DirectUploadResponse directUploadResponse,
    ProgressCallback onProgress,
  }) {
    // TODO
    onProgress(100);
    return null;
  }

  void addHeader(name, value) {
    headers[name] = value;
  }

  String _checkAndDecode(http.Response response) {
    String method = response.request.method;
    String url = response.request.url.toString();
    int code = response.statusCode;
    String body = response.body;
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw HttpStatusException(method, url,
          statusCode: code, responseBody: body);
    }
  }
}

class HttpStatusException implements Exception {
  String method;
  String url;
  String responseBody;
  int statusCode;

  HttpStatusException(this.method, this.url,
      {this.statusCode, this.responseBody});

  @override
  String toString() {
    var msg = "$method $url returned $statusCode";
    if (responseBody != null) msg += " with body: $responseBody";
    return msg;
  }
}
