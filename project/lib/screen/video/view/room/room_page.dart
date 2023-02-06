import 'package:app/feature/video/bloc/room/room_bloc.dart';
import 'package:app/feature/video/me/bloc/me_bloc.dart';
import 'package:app/feature/video/media_devices/bloc/media_devices_bloc.dart';
import 'package:app/feature/video/media_devices/ui/audio_input_selector.dart';
import 'package:app/feature/video/media_devices/ui/video_input_selector.dart';
import 'package:app/feature/video/peers/bloc/peers_bloc.dart';
import 'package:app/feature/video/peers/ui/list_remote_streams.dart';
import 'package:app/feature/video/producers/bloc/producers_bloc.dart';
import 'package:app/feature/video/producers/ui/controls/audio_output.dart';
import 'package:app/feature/video/producers/ui/controls/microphone.dart';
import 'package:app/feature/video/producers/ui/controls/webcam.dart';
import 'package:app/feature/video/producers/ui/renderer/local_stream.dart';
import 'package:app/feature/video/signaling/room_client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'leave.dart';
import 'room_app_bar.dart';
import 'package:account_repository/account_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';

class Room extends StatefulWidget {
  final Account account;
  final Set<Contact> contacts;

  const Room({Key? key, required this.account, required this.contacts})
      : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProducersBloc>(
            lazy: false,
            create: (__) => ProducersBloc(),
          ),
          BlocProvider<PeersBloc>(
            lazy: false,
            create: (context) => PeersBloc(
              mediaDevicesBloc: context.read<MediaDevicesBloc>(),
            ),
          ),
          BlocProvider<MeBloc>(
            lazy: false,
            create: (context) => MeBloc(displayName: 'wzh', id: 'zhxPsrLy'),
          ),
          BlocProvider<RoomBloc>(
            lazy: false,
            create: (__) => RoomBloc(''),
          ),
        ],
        child: RepositoryProvider(
            lazy: false,
            create: (context) {
              final meState = context.read<MeBloc>().state;
              String displayName = meState.displayName;
              String id = meState.id;
              final roomState = context.read<RoomBloc>().state;
              String url = roomState.url;
              Uri? uri = Uri.parse(url);
              return RoomClientRepository(
                peerId: id,
                displayName: displayName,
                url: url.isEmpty
                    ? 'wss://${uri.host}:4443'
                    : 'wss://v3demo.mediasoup.org:4443',
                roomId: uri.queryParameters['roomId'] ??
                    uri.queryParameters['roomid'] ??
                    'nbykfgwb',
                peersBloc: context.read<PeersBloc>(),
                producersBloc: context.read<ProducersBloc>(),
                meBloc: context.read<MeBloc>(),
                roomBloc: context.read<RoomBloc>(),
                mediaDevicesBloc: context.read<MediaDevicesBloc>(),
              )..join();
            },
            child: RoomPage(
              account: widget.account,
              contacts: widget.contacts,
            )));
  }
}

class RoomPage extends StatefulWidget {
  final Account account;
  final Set<Contact> contacts;

  const RoomPage({Key? key, required this.account, required this.contacts})
      : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool show = true;

  void toggleShow() {
    setState(() {
      show = !show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RoomAppBar(
        display: show,
      ),
      body: ExpandableBottomSheet(
        persistentContentHeight: kToolbarHeight + 16,
        expandableContent: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: show ? 1.0 : 0.0,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.4 + 2,
              minHeight: screenHeight * 0.4 + 2,
              maxWidth: 300,
              minWidth: 0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Webcam(),
                      Microphone(),
                      AudioOutput(),
                      Leave(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.mic),
                                Text(
                                  'Audio Input',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                             const AudioInputSelector(),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.videocam),
                                Text(
                                  'Video Input',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                             const VideoInputSelector(),
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         const Icon(Icons.videocam),
                        //         Text(
                        //           'Audio Output',
                        //           style: Theme.of(context).textTheme.headline5,
                        //         ),
                        //       ],
                        //     ),
                        //     AudioOutputSelector(),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        background: GestureDetector(
          onTap: toggleShow,
          child: Stack(
            fit: StackFit.expand,
            children: const [
              ListRemoteStreams(),
              LocalStream(),
            ],
          ),
        ),
      ),
    );
  }
}
