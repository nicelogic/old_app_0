class AuthFailure implements Exception {
  String _errorDescribe;

  AuthFailure({required String errorDescribe}) : _errorDescribe = errorDescribe;
  String get errorDescribe => _errorDescribe;
}
