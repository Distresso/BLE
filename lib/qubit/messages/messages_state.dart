part of 'messages_cubit.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class InitialMessagesState extends MessagesState {}

class NoMessagesState extends MessagesState {}

class MessagesLoadingState extends MessagesState {}

class MessagesLoadedState extends MessagesState {
  final List<PushMessage> messages;

  MessagesLoadedState({this.messages});

  @override
  List<Object> get props => [messages];
}

class NewMessageState extends MessagesState {
  final Map<String, dynamic> message;

  NewMessageState({this.message});

  @override
  List<Object> get props => [message];
}
