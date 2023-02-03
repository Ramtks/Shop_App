class HttpException implements Exception {
  final String message;
  HttpException({required this.message});

  @override
  String toString() {
    return message;
    // return super.toString(); //this yields instance of HttpException
  }
}
