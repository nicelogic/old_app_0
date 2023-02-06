part of 'message_bloc.dart';


@JsonSerializable(explicitToJson: true)
class MessageState extends Equatable {
  final Map<String, Chat> _chats;
  Map<String, Chat> get chats => _chats;

  const MessageState({required final Map<String, Chat> chats}) : _chats = chats;

  MessageState copyWith({final Map<String, Chat>? chats}) {
    return MessageState(chats: chats ?? _chats);
  }

  @override
  List<Object> get props => [_chats];

    factory MessageState.fromJson(Map<String, dynamic> json) {
    try {
      return _$MessageStateFromJson(json);
    } catch (err) {
      return const MessageState(chats: <String, Chat>{});
    }
  }
  Map<String, dynamic> toJson() => _$MessageStateToJson(this);
}

class MessageInitial extends MessageState {
  MessageInitial() : super(chats: {});
}
