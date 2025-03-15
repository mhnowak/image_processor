const fileExtensions = ['ppm'];

bool isAllowedFileExtension(String extension) {
  return fileExtensions.contains(extension);
}
