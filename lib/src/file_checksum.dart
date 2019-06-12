import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';

class FileChecksum {
  final Stream<List<int>> fileContents;
  Digest md5Digest;

  static Future<String> getMd5AsBase64({File file}) async {
    var checksum = FileChecksum(file.openRead());
    await checksum.compute();
    return checksum.base64;
  }

  FileChecksum(this.fileContents);

  String get base64 => base64Encode(rawBytes);

  List<int> get rawBytes => md5Digest.bytes;

  Future<void> compute() async {
    var digestSink = DigestSink();
    ByteConversionSink md5Sink = md5.startChunkedConversion(digestSink);
    await for (List<int> chunk in fileContents) {
      md5Sink.add(chunk);
    }
    md5Sink.close();
    md5Digest = digestSink.value;
  }
}
