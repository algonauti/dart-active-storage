library active_storage;

import 'dart:io';

import 'package:meta/meta.dart';

import 'src/direct_upload.dart';
import 'src/file_checksum.dart';
import 'src/uploader.dart';

export 'src/direct_upload.dart';
export 'src/exceptions.dart';

class ActiveStorage {
  final Uploader uploader;

  ActiveStorage({@required String directUploadURL})
      : uploader = Uploader(directUploadURL);

  Future<DirectUploadResponse> upload({
    @required String fileName,
    @required String fileMimeType,
    @required File file,
    ProgressCallback onProgress,
  }) async {
    int fileSize = await file.length();
    String checksum = await FileChecksum.getMd5AsBase64(file: file);
    DirectUploadResponse response = await uploader.directUpload(
      DirectUploadRequest(
        fileName: fileName,
        contentType: fileMimeType,
        byteSize: fileSize,
        checksum: checksum,
      ),
    );
    await uploader.fileUpload(
      fileContents: file.openRead(),
      byteSize: fileSize,
      directUploadResponse: response,
      onProgress: onProgress,
    );
    return Future.value(response);
  }

  void addHeader(name, value) {
    uploader.addHeader(name, value);
  }
}
