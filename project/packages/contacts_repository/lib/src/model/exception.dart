enum ContactErrorCode { undefined, userUndefined }

class ContactFailure implements Exception {
  final String _errorDescribe;
  final ContactErrorCode _errorCode;

  ContactFailure(
      {final String errorDescribe = '',
      final ContactErrorCode errorCode = ContactErrorCode.undefined})
      : _errorDescribe = errorDescribe,
        _errorCode = errorCode;

  String get errorDescribe => _errorDescribe;
  ContactErrorCode get errorCode => _errorCode;
}
