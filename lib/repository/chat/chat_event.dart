abstract class ChatEvent {}

class LoadConversations extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String conversationId;
  final String message;

  SendMessage(this.conversationId, this.message);
}