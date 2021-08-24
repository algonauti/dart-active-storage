import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';

import 'exceptions.dart';

class FileChecksum {
  final Stream<List<int>> fileContents;
  late Digest md5Digest;

  static Future<String> getMd5AsBase64({required File file}) async {
    Stream<List<int>> _fileContents;
    try {
      _fileContents = file.openRead();
    } on UnsupportedError catch (e) {
      throw FileChecksumException(e.message);
    } on FileSystemException catch (e) {
      throw FileChecksumException(e.message);
    }
    FileChecksum checksum = FileChecksum(_fileContents);
    ;
    await checksum.compute();
    return checksum.base64;
  }

  FileChecksum(this.fileContents);

  String get base64 {
    try {
      return base64Encode(rawBytes);
    } on FormatException catch (e) {
      throw FileChecksumException(e.message);
    } on ArgumentError catch (e) {
      throw FileChecksumException(e.message);
    }
  }

  List<int> get rawBytes => md5Digest.bytes;

  Future<void> compute() async {
    var digestSink = DigestSink();
    try {
      ByteConversionSink md5Sink = md5.startChunkedConversion(digestSink);
      await for (List<int> chunk in fileContents) {
        md5Sink.add(chunk);
      }
      md5Sink.close();
      md5Digest = digestSink.value;
    } on UnsupportedError catch (e) {
      throw FileChecksumException(e.message);
    }
  }
}
