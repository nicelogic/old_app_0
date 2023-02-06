import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc(String url)
      : super(
          RoomState(
              url: url.isNotEmpty
                  ? url.replaceAll('roomid', 'roomId')
                  : 'https://v3demo.mediasoup.org/?roomId=nbykfgwb'),
        ) {
    on<RoomSetActiveSpeakerId>(_onRoomSetActiveSpeakerId,
        transformer: sequential());
  }

  _onRoomSetActiveSpeakerId(
      RoomSetActiveSpeakerId event, Emitter<RoomState> emit) async {
    emit(state.newActiveSpeaker(activeSpeakerId: event.speakerId));
  }
}
