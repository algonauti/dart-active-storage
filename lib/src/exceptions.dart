class FileChecksumException implements Exception {
  final String message;
  FileChecksumException(this.message);
}

class HttpStatusException implements Exception {
  String method;
  String url;
  String responseBody;
  String requestBody;
  int statusCode;

  HttpStatusException(
    this.method,
    this.url, {
    this.statusCode,
    this.requestBody,
    this.responseBody,
  });

  @override
  String toString() =>
      "HTTP error: $method $url\n\n$requestBody\n$responseBody";
}

class ClientError extends HttpStatusException {
  ClientError(
    String method,
    String url,
    int statusCode,
    String requestBody,
    String responseBody,
  ) : super(
          method,
          url,
          statusCode: statusCode,
          requestBody: requestBody,
          responseBody: responseBody,
        );

  @override
  String toString() =>
      "Client request error: $method $url\n\n$requestBody\n$responseBody";
}

class ServerError extends HttpStatusException {
  ServerError(
    String method,
    String url,
    int statusCode,
    String requestBody,
    String responseBody,
  ) : super(
          method,
          url,
          statusCode: statusCode,
          requestBody: requestBody,
          responseBody: responseBody,
        );

  @override
  String toString() =>
      "Server processing error: $method $url\n\n$requestBody\n$responseBody";
}

class NoNetworkError implements Exception {}

class NetworkError implements Exception {}

class InvalidDataReceived implements Exception {
  String message;
  InvalidDataReceived(this.message);
}
