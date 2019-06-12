class FileChecksum {
  final Stream<List<int>> fileContents;
  final int byteSize;

  FileChecksum(this.fileContents, this.byteSize);

  String get md5 => 'blah'; // TODO
}
