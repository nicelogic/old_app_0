import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'me_event.dart';
part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  MeBloc({required String id, required String displayName})
      : super(MeState(
          webcamInProgress: false,
          shareInProgress: false,
          id: id,
          displayName: displayName,
        )) {
    on<MeSetWebcamInProgress>(_onMeSetWebCamInProgress,
        transformer: sequential());
  }

  _onMeSetWebCamInProgress(
      MeSetWebcamInProgress event, Emitter<MeState> emit) async {
    emit(MeState.copy(state, webcamInProgress: event.progress));
  }
}
