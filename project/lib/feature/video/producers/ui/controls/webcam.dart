import 'package:app/feature/video/producers/bloc/producers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/feature/video/media_devices/bloc/media_devices_bloc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

class Webcam extends StatelessWidget {
  const Webcam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int videoInputDevicesLength = context.select(
            (MediaDevicesBloc bloc) =>
        bloc.state.videoInputs.length);
    final Producer? webcam = context
        .select((ProducersBloc bloc) => bloc.state.webcam);
    if (videoInputDevicesLength == 0) {
      return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.videocam,
          color: Colors.grey,
          // size: screenHeight * 0.045,
        ),
      );
    }
    if (webcam == null) {
      return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.grey;
            return null;
          }),
          shadowColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.grey;
            return null;
          }),
        ),
        onPressed: () {
          // if (!inProgress) {
            // context
            //     .read<RoomClientRepository>()
            //     .enableWebcam();
          // }
        },
        child: const Icon(
          Icons.videocam_off,
          color: Colors.black,
          // size: screenHeight * 0.045,
        ),
      );
    }
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) return Colors.grey;
          return null;
        }),
        shadowColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) return Colors.grey;
          return null;
        }),
      ),
      onPressed: () {
        // if (!inProgress) {
          // context
          //     .read<RoomClientRepository>()
          //     .disableWebcam();
        // }
      },
      child: const Icon(
        Icons.videocam,
        color: Colors.black,
        // size: screenHeight * 0.045,
      ),
    );
  }
}
