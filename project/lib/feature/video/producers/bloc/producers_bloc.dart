import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

part 'producers_event.dart';
part 'producers_state.dart';

class ProducersBloc extends Bloc<ProducersEvent, ProducersState> {
  ProducersBloc() : super(const ProducersState()) {
    on<ProducerAdd>(_onProducerAdd, transformer: sequential());
    on<ProducerRemove>(_onProducerRemove, transformer: sequential());
    on<ProducerResumed>(_onProducerResume, transformer: sequential());
    on<ProducerPaused>(_onProducerPaused, transformer: sequential());
  }

  _onProducerAdd(ProducerAdd event, Emitter<ProducersState> emit) async {
    switch (event.producer.source) {
      case 'mic': {
        emit(ProducersState.copy(state, mic: event.producer));
        break;
      }
      case 'webcam': {
        emit(ProducersState.copy(state, webcam: event.producer));
        break;
      }
      case 'screen': {
        emit(ProducersState.copy(state, screen: event.producer));
        break;
      }
      default: break;
    }
  }

  _onProducerRemove(ProducerRemove event, Emitter<ProducersState> emit) async {
    switch (event.source) {
      case 'mic': {
        state.mic?.close();
        emit(ProducersState.removeMic(state));
        break;
      }
      case 'webcam': {
        state.webcam?.close();
        emit(ProducersState.removeWebcam(state));
        break;
      }
      case 'screen': {
        state.screen?.close();
        emit(ProducersState.removeScreen(state));
        break;
      }
      default: break;
    }
  }

  _onProducerResume(ProducerResumed event, Emitter<ProducersState> emit) async {
    switch (event.source) {
      case 'mic': {
        emit(ProducersState.copy(state, mic: state.mic!.resumeCopy()));
        break;
      }
      case 'webcam': {
        emit(ProducersState.copy(state, webcam: state.webcam!.resumeCopy()));
        break;
      }
      case 'screen': {
        emit(ProducersState.copy(state, screen: state.screen?.resumeCopy()));
        break;
      }
      default: break;
    }
  }

  _onProducerPaused(ProducerPaused event, Emitter<ProducersState> emit) async {
    switch (event.source) {
      case 'mic': {
        emit(ProducersState.copy(state, mic: state.mic!.pauseCopy()));
        break;
      }
      case 'webcam': {
        emit(ProducersState.copy(state, webcam: state.webcam!.pauseCopy()));
        break;
      }
      case 'screen': {
        emit(ProducersState.copy(state, screen: state.screen!.pauseCopy()));
        break;
      }
      default: break;
    }
  }
}
