// ignore: uri_does_not_exist
import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:app/feature/video/video.dart';

class P2pVideoPage extends StatefulWidget {
  final Account _account;
  final String _contactId;
  final bool _isCaller;

  const P2pVideoPage(
      {Key? key,
      required final Account account,
      required final String contactId,
      final bool? isCaller})
      : _account = account,
        _contactId = contactId,
        _isCaller = isCaller ?? true,
        super(key: key);

  @override
  _P2pVideoPageState createState() => _P2pVideoPageState();
}

class _P2pVideoPageState extends State<P2pVideoPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initRenderers();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final rtcSignalingRepository = context.read<P2pSignalingRepository>();
    final videoBloc = context.read<P2pVideoBloc>();
    return BlocConsumer<P2pVideoBloc, P2pVideoState>(
        listenWhen: (previousState, state) {
      return previousState.localStream.isReady != state.localStream.isReady ||
          previousState.remoteStream.isReady != state.remoteStream.isReady ||
          previousState.isCalling != state.isCalling;
    }, listener: (context, state) {
      _localRenderer.srcObject = state.localStream.stream;
      _remoteRenderer.srcObject = state.remoteStream.stream;
      setState(() {});
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            leading: const CloseButton(color: Colors.white),
            title: const Text(
              '音视频聊天',
              style: TextStyle(color: Colors.white),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.isCalling
              ? SizedBox(
                  width: 200.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FloatingActionButton(
                          child: const Icon(Icons.switch_camera,
                              color: Colors.white),
                          onPressed: videoBloc.switchCamera,
                          heroTag: 'switchCamera',
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            videoBloc.hangUp();
                            context.popRoute();
                          },
                          tooltip: 'Hangup',
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.pink,
                          heroTag: 'hangup',
                        ),
                        FloatingActionButton(
                          child: state.isMute
                              ? const Icon(
                                  Icons.mic_off,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.mic_sharp,
                                  color: Colors.white,
                                ),
                          onPressed: videoBloc.muteMic,
                          heroTag: 'muteMic',
                        )
                      ]))
              : (widget._isCaller
                  ? FloatingActionButton(
                      onPressed: () {
                        rtcSignalingRepository.invite(widget._account.id,
                            widget._contactId, 'video', false);
                        videoBloc.add(NewCall());
                      },
                      tooltip: 'call',
                      child: const Icon(Icons.call_outlined, color: Colors.white),
                      heroTag: 'call',
                    )
                  : SizedBox(
                      width: 200.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FloatingActionButton(
                              child:
                                  const Icon(Icons.check, color: Colors.white),
                              onPressed: () {
                                videoBloc.add(NewCall());
                              },
                              heroTag: 'check',
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                videoBloc.hangUp();
                                context.popRoute();
                              },
                              tooltip: 'close',
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.pink,
                              heroTag: 'close',
                            ),
                          ]))),
          body: OrientationBuilder(builder: (context, orientation) {
            return Stack(children: <Widget>[
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Text(''),
                    decoration: const BoxDecoration(color: Colors.black54),
                  )),
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(_remoteRenderer),
                    decoration: const BoxDecoration(color: Colors.black54),
                  )),
              Positioned(
                left: 20.0,
                top: 20.0,
                child: Container(
                  width: orientation == Orientation.portrait ? 90.0 : 120.0,
                  height: orientation == Orientation.portrait ? 120.0 : 90.0,
                  child: RTCVideoView(_localRenderer, mirror: true),
                  decoration: const BoxDecoration(color: Colors.black54),
                ),
              ),
            ]);
          }));
    });
  }
}
