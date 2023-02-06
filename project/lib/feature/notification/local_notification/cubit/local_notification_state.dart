part of 'local_notification_cubit.dart';

abstract class LocalNotificationState extends Equatable {
  const LocalNotificationState();

  @override
  List<Object> get props => [];
}

class LocalNotificationInitial extends LocalNotificationState {}

class LocalNotificationInitializing extends LocalNotificationState {}

class LocalNotificationInitialized extends LocalNotificationState {}

class LocalNewMessageNotification extends LocalNotificationState {
  final String _chatId;
  String get chatId => _chatId;
  final _currentTime = DateTime.now();

  LocalNewMessageNotification({required final String chatId}) : _chatId = chatId;
  @override
  List<Object> get props => [_chatId, _currentTime];
}
