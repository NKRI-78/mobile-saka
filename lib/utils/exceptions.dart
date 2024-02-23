class ConnectionTimeoutException implements Exception {
  final dynamic cause;
  ConnectionTimeoutException([this.cause]);

  @override
  String toString() {
    Object? cause = this.cause;
    if (cause == null) return "ConnectionTimeoutException";
    return cause.toString();
  }
}

class CustomException implements Exception {
  final dynamic cause;
  CustomException([this.cause]);

  @override
  String toString() {
    Object? cause = this.cause;
    if (cause == null) return "ConnectionTimeoutException";
    return cause.toString();
  }
}

class Exception400 implements Exception {
  final dynamic cause;
  Exception400([this.cause]);

  @override
  String toString() {
    Object? cause = this.cause;
    if (cause == null) return "ConnectionTimeoutException";
    return cause.toString();
  }
}

class EmptyException implements Exception {
  final dynamic cause;
  EmptyException([this.cause]);

  @override
  String toString() {
    Object? cause = this.cause;
    if (cause == null) return "ConnectionTimeoutException";
    return cause.toString();
  }
}