import 'package:meta/meta.dart';

import 'direct_upload.dart';

typedef ProgressCallback = void Function(int progressPercent);

class Uploader {
  final String directUploadURL;

  Uploader(this.directUploadURL);

  Future<DirectUploadResponse> directUpload(DirectUploadRequest) {
    // TODO
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
}
