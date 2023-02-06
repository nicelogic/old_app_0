import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'media_devices_event.dart';
part 'media_devices_state.dart';

class MediaDevicesBloc extends Bloc<MediaDevicesEvent, MediaDevicesState> {
  MediaDevicesBloc() : super(const MediaDevicesState()) {
    on<MediaDeviceLoadDevices>(_onLoadDevices, transformer: sequential());
    on<MediaDeviceSelectAudioInput>(_onSelectAudioInput,
        transformer: sequential());
    on<MediaDeviceSelectAudioOutput>(_onSelectAudioOutput,
        transformer: sequential());
    on<MediaDeviceSelectVideoInput>(_onSelectVideoInput,
        transformer: sequential());
  }

  _onSelectAudioInput(MediaDeviceSelectAudioInput event,
      Emitter<MediaDevicesState> emit) async {
    emit(state.copyWith(
      selectedAudioInput: event.device,
    ));
  }

  _onSelectAudioOutput(MediaDeviceSelectAudioOutput event,
      Emitter<MediaDevicesState> emit) async {
    emit(state.copyWith(
      selectedAudioOutput: event.device,
    ));
  }

  _onSelectVideoInput(MediaDeviceSelectVideoInput event,
      Emitter<MediaDevicesState> emit) async {
    emit(state.copyWith(
      selectedVideoInput: event.device,
    ));
  }

  _onLoadDevices(
      MediaDeviceLoadDevices event, Emitter<MediaDevicesState> emit) async {
    try {
      final List<MediaDeviceInfo> devices =
          await navigator.mediaDevices.enumerateDevices();

      final List<MediaDeviceInfo> audioInputs = [];
      final List<MediaDeviceInfo> audioOutputs = [];
      final List<MediaDeviceInfo> videoInputs = [];

      for (var device in devices) {
        switch (device.kind) {
          case 'audioinput':
            audioInputs.add(device);
            break;
          case 'audiooutput':
            audioOutputs.add(device);
            break;
          case 'videoinput':
            videoInputs.add(device);
            break;
          default:
            break;
        }
      }
      MediaDeviceInfo? selectedAudioInput;
      MediaDeviceInfo? selectedAudioOutput;
      MediaDeviceInfo? selectedVideoInput;
      if (audioInputs.isNotEmpty) {
        selectedAudioInput = audioInputs.first;
      }
      if (audioOutputs.isNotEmpty) {
        selectedAudioOutput = audioOutputs.first;
      }
      if (videoInputs.isNotEmpty) {
        selectedVideoInput = videoInputs.first;
      }

      emit(MediaDevicesState(
        audioInputs: audioInputs,
        audioOutputs: audioOutputs,
        videoInputs: videoInputs,
        selectedAudioInput: selectedAudioInput,
        selectedAudioOutput: selectedAudioOutput,
        selectedVideoInput: selectedVideoInput,
      ));
    } catch (e) {
      log(e.toString());
    }
  }
}
