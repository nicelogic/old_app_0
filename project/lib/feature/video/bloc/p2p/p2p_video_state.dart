part of 'p2p_video_bloc.dart';

class P2pVideoState extends Equatable {
  final bool _isInCalling;
  bool get isCalling => _isInCalling;
  final bool _isMute;
  bool get isMute => _isMute;
  final MediaStreamState _localStream = MediaStreamState();
  MediaStreamState get localStream => _localStream;
  final MediaStreamState _remoteStream = MediaStreamState();
  MediaStreamState get remoteStream => _remoteStream;

  P2pVideoState({
    required final bool isInCalling,
    required final bool isMute,
    final MediaStream? localStream,
    final MediaStream? remoteStream,
  })  : _isInCalling = isInCalling,
        _isMute = isMute {
    _localStream.stream = localStream;
    _localStream.isReady = localStream != null;
    _remoteStream.stream = remoteStream;
    _remoteStream.isReady = remoteStream != null;
  }

  @override
  List<Object> get props =>
      [_isInCalling, _isMute, _localStream, _remoteStream];

  P2pVideoState copyWith(
      {final bool? isInCalling,
      final bool? isMute,
      final MediaStream? localStream,
      final bool? isLocalStreamRemoved,
      final MediaStream? remoteStream,
      final bool? isRemoteStreamRemoved}) {
    MediaStream? remoteStreamState;
    if (isRemoteStreamRemoved == null) {
      remoteStreamState = remoteStream ?? _remoteStream.stream;
    } else {
      remoteStreamState = null;
    }
    MediaStream? localStreamState;
    if (isLocalStreamRemoved == null) {
      localStreamState = localStream ?? _localStream.stream;
    } else {
      localStreamState = null;
    }
    return P2pVideoState(
        isInCalling: isInCalling ?? _isInCalling,
        isMute: isMute ?? _isMute,
        localStream: localStreamState,
        remoteStream: remoteStreamState);
  }
}

class VideoInitial extends P2pVideoState {
  VideoInitial() : super(isInCalling: false, isMute: false);
}
