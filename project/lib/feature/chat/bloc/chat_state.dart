part of 'chat_bloc.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class ChatState extends Equatable {
  MessageWithChatId? lastMessageWithChatIdForNotification;
  final Map<String, Chat> _chats;
  Map<String, Chat> get chats => _chats;

  ChatState({required final Map<String, Chat> chats, this.lastMessageWithChatIdForNotification}) : _chats = chats;

  @override
  List<Object> get props => [_chats];

  factory ChatState.fromJson(Map<String, dynamic> json) {
    try {
      return _$ChatStateFromJson(json);
    } catch (err) {
      return ChatState(chats: const <String, Chat>{});
    }
  }
  Map<String, dynamic> toJson() => _$ChatStateToJson(this);
}

// ignore: must_be_immutable
class ChatInitial extends ChatState {
  ChatInitial() : super(chats: <String, Chat>{});
}
