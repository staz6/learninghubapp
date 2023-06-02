import 'package:learninghubapp/models/chat_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Conversation> conversations;

  ChatLoaded(this.conversations);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
class ChatMessage {
  final String senderId;
  final String content;

  ChatMessage({required this.senderId, required this.content});
}
