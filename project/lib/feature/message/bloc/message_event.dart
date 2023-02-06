part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesEvent extends MessageEvent {
  final String _chatId;
  String get chatId => _chatId;
  const GetMessagesEvent({required final String chatId}) : _chatId = chatId;

  @override
  List<Object> get props => [_chatId];
}

abstract class NewMessageEvent extends MessageEvent {
  final String _chatId;
  String get chatId => _chatId;
  final Message _message;
  Message get message => _message;
  const NewMessageEvent(
      {required final String chatId, required final Message message})
      : _chatId = chatId,
        _message = message;

  @override
  List<Object> get props => [_message, _chatId];
}

class NewSendMessageEvent extends NewMessageEvent {
  const NewSendMessageEvent(
      {required final String chatId, required final Message message})
      : super(chatId: chatId, message: message);
}

class NewReceivedMessageEvent extends NewMessageEvent {
  const NewReceivedMessageEvent(
      {required final String chatId, required final Message message})
      : super(chatId: chatId, message: message);
}

class MessageLogout extends MessageEvent {}
