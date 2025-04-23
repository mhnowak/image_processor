extension ImageListStringUtils on List<String> {
  String readNextNonCommentLine() {
    while (isNotEmpty && first.startsWith('#')) {
      removeAt(0);
    }
    return removeAt(0).trim();
  }
}
