import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'direct_upload.dart';
import 'exceptions.dart';

class Uploader {
  final String directUploadURL;
  var headers = Map<String, String>();

  Uploader(this.directUploadURL);

  Future<DirectUploadResponse> directUpload(
      DirectUploadRequest requestData) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    requestHeaders.addAll(headers);
    http.Response response =
        await _safelyRun<http.Response>(() async => await http.post(
              directUploadURL,
              headers: requestHeaders,
              body: requestData.toJson(),
            ));
    String responseBody = _checkAndDecode(response);
    return DirectUploadResponse.fromJson(responseBody);
  }

  Future<void> fileUpload({
    @required Stream<List<int>> fileContents,
    @required int byteSize,
    @required DirectUploadResponse directUploadResponse,
    ProgressCallback onProgress,
  }) async {
    await _safelyRun<void>(() async {
      HttpClientRequest request =
          await HttpClient().putUrl(_getDirectUploadUri(directUploadResponse));
      directUploadResponse.headers.forEach((name, value) {
        request.headers.set(name, value);
      });
      request.headers.set('content-length', byteSize);
      int uploaded = 0;
      await request.addStream(fileContents.map((chunk) {
        uploaded += chunk.length;
        if (onProgress != null) onProgress(uploaded / byteSize * 100.0);
        return chunk;
      }));
      HttpClientResponse response = await request.close();
      if (response.statusCode < 200 || response.statusCode > 300) {
        String responseText = '';
        await for (String textChunk in utf8.decoder.bind(response)) {
          responseText += textChunk;
        }
        _throwHttpException(
          request.method,
          directUploadResponse.uploadUrl,
          statusCode: response.statusCode,
          responseBody: responseText,
        );
      }
    });
  }

  void addHeader(name, value) {
    headers[name] = value;
  }

  Uri _getDirectUploadUri(DirectUploadResponse directUploadResponse) {
    try {
      return Uri.parse(directUploadResponse.uploadUrl);
    } on FormatException catch (e) {
      throw InvalidDataReceived(e.message);
    }
  }

  String _checkAndDecode(http.Response response) {
    http.Request request = response.request;
    String method = request.method;
    String url = request.url.toString();
    int code = response.statusCode;
    try {
      String responseBody = utf8.decode(response.bodyBytes);
      String requestBody = request.body;
      if (code < 200 || code > 300) {
        _throwHttpException(
          method,
          url,
          statusCode: code,
          requestBody: requestBody,
          responseBody: responseBody,
        );
      }
      return responseBody;
    } on FormatException catch (e) {
      throw InvalidDataReceived(e.message);
    }
  }

  void _throwHttpException(
    String method,
    String url, {
    int statusCode,
    String requestBody,
    String responseBody,
  }) {
    if (statusCode > 400 && statusCode < 500) {
      throw ClientError(method, url, statusCode, requestBody, responseBody);
    } else if (statusCode >= 500 && statusCode <= 599) {
      throw ServerError(method, url, statusCode, requestBody, responseBody);
    } else {
      throw HttpStatusException(
        method,
        url,
        statusCode: statusCode,
        requestBody: requestBody,
        responseBody: responseBody,
      );
    }
  }
}

Future<T> _safelyRun<T>(Future<T> method()) async {
  try {
    return await method();
  } on SocketException {
    throw NoNetworkError();
  } on http.ClientException {
    throw NetworkError();
  }
}
