class FileChecksum {
  final Stream<List<int>> fileContents;

  FileChecksum(this.fileContents);

  String get md5 => 'blah'; // TODO
}
