class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  const NetworkException();
}

class AuthException implements Exception {
  final String message;
  const AuthException({required this.message});
}

class DuplicateReceiptException implements Exception {
  const DuplicateReceiptException();
}
