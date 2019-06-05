library active_storage;

import 'package:meta/meta.dart';

import 'src/direct_upload.dart';
import 'src/uploader.dart';

export 'src/direct_upload.dart';

class ActiveStorage {
  static Future<DirectUploadResponse> upload({
    @required String fileName,
    @required String fileMimeType,
    @required int fileSize,
    @required Stream<List<int>> fileContents,
    @required String directUploadURL,
    ProgressCallback onProgress,
  }) async {
    final uploader = Uploader(directUploadURL);
    DirectUploadResponse response = await uploader.directUpload(
      DirectUploadRequest(
        fileName: fileName,
        contentType: fileMimeType,
        byteSize: fileSize,
        fileContents: fileContents,
      ),
    );
    await uploader.fileUpload(
      fileContents: fileContents,
      directUploadResponse: response,
      onProgress: onProgress,
    );
    return Future.value(response);
  }
}
