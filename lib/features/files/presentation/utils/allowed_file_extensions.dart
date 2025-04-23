const fileExtensions = ['ppm', 'pgm', 'pbm'];

bool isAllowedFileExtension(String extension) {
  return fileExtensions.contains(extension);
}
