class Publication {
  final String _id;
  String get id => _id;
  final String _accountId;
  String get accountId => _accountId;
  final String _targetId;
  String get targetId => _targetId;
  final String _event;
  String get event => _event;
  final String _info;
  String get info => _info;
  final String _state;
  String get state => _state;
  final String? _replyEvent;
  String? get replyEvent => _replyEvent;
  final String? _replyInfo;
  String? get replyInfo => _replyInfo;

  const Publication(
      {required String id,
      required String accountId,
      required String targetId,
      required String event,
      required String info,
      required String state,
      final String? replyEvent,
      final String? replyInfo})
      : _id = id,
        _accountId = accountId,
        _targetId = targetId,
        _event = event,
        _info = info,
        _state = state,
        _replyEvent = replyEvent,
        _replyInfo = replyInfo;
}
