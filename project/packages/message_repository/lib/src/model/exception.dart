enum MessageErrorCode { Undefined }

class MessageFailure implements Exception {
  final String _errorDescribe;
  final MessageErrorCode _errorCode;

  MessageFailure(
      {final String errorDescribe = '',
      final MessageErrorCode errorCode = MessageErrorCode.Undefined})
      : _errorDescribe = errorDescribe,
        _errorCode = errorCode;

  String get errorDescribe => _errorDescribe;
  MessageErrorCode get errorCode => _errorCode;
}
