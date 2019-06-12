import 'package:meta/meta.dart';

class DirectUploadResponse {
  String id;
  String key;
  String signedId;
  String uploadUrl;
  Map<String, String> headers;
// TODO Constructor
}

class DirectUploadRequest {
  final String fileName;
  final String contentType;
  final int byteSize;
  final String checksum;

  DirectUploadRequest({
    @required this.fileName,
    @required this.contentType,
    @required this.byteSize,
    @required this.checksum,
  });
}
