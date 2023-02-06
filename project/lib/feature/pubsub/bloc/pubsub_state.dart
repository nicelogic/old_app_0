part of 'pubsub_bloc.dart';

abstract class PubsubState extends Equatable {
  const PubsubState();
  
  @override
  List<Object> get props => [];
}

class PubsubInitial extends PubsubState {}
