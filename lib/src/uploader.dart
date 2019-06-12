import 'package:meta/meta.dart';

import 'direct_upload.dart';

typedef ProgressCallback = void Function(int progressPercent);

class Uploader {
  final String directUploadURL;
  var headers = Map<String, String>();

  Uploader(this.directUploadURL);

  Future<DirectUploadResponse> directUpload(DirectUploadRequest) {
    // TODO use headers
    return Future.value(DirectUploadResponse());
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
}
