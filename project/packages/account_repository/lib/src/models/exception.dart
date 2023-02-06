enum AccountErrorCode { Undefined, UserUndefined }

class AccountFailure implements Exception {
  final String _errorDescribe;
  final AccountErrorCode _errorCode;

  AccountFailure(
      {final String errorDescribe = '',
      final AccountErrorCode errorCode = AccountErrorCode.Undefined})
      : _errorDescribe = errorDescribe,
        _errorCode = errorCode;

  String get errorDescribe => _errorDescribe;
  AccountErrorCode get errorCode => _errorCode;
}
