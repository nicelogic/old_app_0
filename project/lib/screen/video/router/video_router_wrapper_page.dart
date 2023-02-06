import 'package:app/feature/account/account.dart';
import 'package:app/feature/video/video.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';

class VideoRouterWrapperPage extends StatelessWidget {
  const VideoRouterWrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<P2pVideoBloc>(
        create: (_) => P2pVideoBloc(
            rtcSignalingRepository: context.read<P2pSignalingRepository>(),
            accountBloc: context.read<AccountBloc>()),
      ),
      BlocProvider<MediaDevicesBloc>(
        lazy: false,
        create: (__) => MediaDevicesBloc()..add(MediaDeviceLoadDevices()),
      ),
    ], child: const AutoRouter());
  }
}
