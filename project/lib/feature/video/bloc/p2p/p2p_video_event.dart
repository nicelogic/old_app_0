part of 'p2p_video_bloc.dart';

abstract class P2pVideoEvent extends Equatable {
  const P2pVideoEvent();

  @override
  List<Object> get props => [];
}

class NewCall extends P2pVideoEvent {}

class CloseCall extends P2pVideoEvent {}

class Mute extends P2pVideoEvent {
  final bool _isMute;
  bool get isMute => _isMute;

  const Mute(final bool isMute) : _isMute = isMute;

  @override
  List<Object> get props => [_isMute];
}

class LocalStreamReady extends P2pVideoEvent {
  final MediaStream _localStream;
  MediaStream get localStream => _localStream;

  const LocalStreamReady(final MediaStream localStream)
      : _localStream = localStream;

  @override
  List<Object> get props => [_localStream];
}

class RemoteStreamReady extends P2pVideoEvent {
  final MediaStream _remoteStream;
  MediaStream get remoteStream => _remoteStream;

  const RemoteStreamReady(final MediaStream remoteStream)
      : _remoteStream = remoteStream;

  @override
  List<Object> get props => [_remoteStream];
}

class RemoteStreamRemoved extends P2pVideoEvent {}
