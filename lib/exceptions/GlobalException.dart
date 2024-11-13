class GlobalException implements Exception {
  final String message;

  GlobalException(this.message);

  @override
  String toString() {
    return message;
  }
}