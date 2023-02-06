import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// ignore: must_be_immutable
class MediaStreamState extends Equatable {
  MediaStream? stream;
  bool isReady = false;

  @override
  List<Object> get props => [isReady];
}
