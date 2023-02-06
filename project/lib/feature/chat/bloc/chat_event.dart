part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatsEvent extends ChatEvent {
  final String _accountId;
  String get accountId => _accountId;

  const GetChatsEvent(this._accountId);

  @override
  List<Object> get props => [_accountId];
}

class NewChatOrNewMessageEvent extends ChatEvent {
  final Message _message;
  Message get message => _message;
  final String _chatId;
  String get chatId => _chatId;

  const NewChatOrNewMessageEvent(this._chatId, this._message);

  @override
  List<Object> get props => [_chatId, _message];
}

class ChatLogout extends ChatEvent {}
