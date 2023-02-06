enum PubsubErrorCode { Undefined }

class PubsubFailure implements Exception {
  final String _errorDescribe;
  final PubsubErrorCode _errorCode;

  PubsubFailure(
      {final String errorDescribe = '',
      final PubsubErrorCode errorCode = PubsubErrorCode.Undefined})
      : _errorDescribe = errorDescribe,
        _errorCode = errorCode;

  String get errorDescribe => _errorDescribe;
  PubsubErrorCode get errorCode => _errorCode;
}
