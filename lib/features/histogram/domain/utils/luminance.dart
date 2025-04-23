int luminance(int r, int g, int b) {
  return (0.299 * r + 0.587 * g + 0.114 * b).round();
}
