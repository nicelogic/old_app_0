
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';
import 'package:app/feature/account/account.dart';
import 'package:app/feature/video/video.dart';

part 'p2p_video_event.dart';
part 'p2p_video_state.dart';

class P2pVideoBloc extends Bloc<P2pVideoEvent, P2pVideoState> {
  final P2pSignalingRepository _rtcSignalingRepository;
  // final RouterCubit _routerCubit;
  final AccountBloc _accountBloc;
  Session? _session;
  MediaStream? localStream;
  MediaStream? remoteSteam;

  P2pVideoBloc(
      {required final P2pSignalingRepository rtcSignalingRepository,
      required final AccountBloc accountBloc})
      : _rtcSignalingRepository = rtcSignalingRepository,
        _accountBloc = accountBloc,
        super(VideoInitial()) {
    _rtcSignalingRepository.connect();
    _rtcSignalingRepository.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
          break;
        case SignalingState.ConnectionOpen:
          _rtcSignalingRepository.send('new', {
            'name': '',
            'id': _accountBloc.state.account.id,
            'user_agent': ''
          });
          break;
      }
    };

    _rtcSignalingRepository.onCallStateChange =
        (Session session, CallState state) {
      switch (state) {
        case CallState.CallStateNew:
          _session = session;
          final sessionId = _session!.sid;
          final callerId = sessionId.substring(0, sessionId.indexOf('-'));
          if (callerId != _accountBloc.state.account.id) {
            // _routerCubit.routePage(P2pVideoPage(
            //   account: _accountBloc.state.account,
            //   contactId: _session!.pid,
            //   isCaller: false,
            // ));
          }
          break;
        case CallState.CallStateBye:
          _session = null;
          add(CloseCall());
          // _routerCubit.popPage();
          break;
        case CallState.CallStateInvite:
        case CallState.CallStateConnected:
        case CallState.CallStateRinging:
      }
    };

    _rtcSignalingRepository.onLocalStream = ((stream) {
      add(LocalStreamReady(stream));
    });

    _rtcSignalingRepository.onAddRemoteStream = ((_, stream) {
      add(RemoteStreamReady(stream));
    });

    _rtcSignalingRepository.onRemoveRemoteStream = ((_, stream) {
      add(RemoteStreamRemoved());
    });

    on<NewCall>(
        (event, emit) => emit(state.copyWith(
            isInCalling: true,
            localStream: state._localStream.stream,
            remoteStream: state._remoteStream.stream)),
        transformer: sequential());
    on<CloseCall>(
        (event, emit) => emit(state.copyWith(
            isInCalling: false,
            isLocalStreamRemoved: true,
            isRemoteStreamRemoved: true)),
        transformer: sequential());
    on<Mute>((event, emit) => emit(state.copyWith(isMute: event.isMute)),
        transformer: sequential());
    on<LocalStreamReady>(
        (event, emit) => emit(state.copyWith(localStream: event.localStream)),
        transformer: sequential());
    on<RemoteStreamReady>(
        (event, emit) => emit(state.copyWith(remoteStream: event.remoteStream)),
        transformer: sequential());
    on<RemoteStreamRemoved>(
        (event, emit) => emit(state.copyWith(isRemoteStreamRemoved: true)),
        transformer: sequential());
  }
  hangUp() {
    if (_session != null) {
      _rtcSignalingRepository.bye(_accountBloc.state.account.id, _session!.sid);
      add(CloseCall());
    }
  }

  switchCamera() {
    _rtcSignalingRepository.switchCamera();
  }

  muteMic() {
    final isMute = _rtcSignalingRepository.muteMic();
    add(Mute(isMute));
  }
}
