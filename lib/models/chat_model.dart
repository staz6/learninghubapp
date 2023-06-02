import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final Timestamp lastUpdated;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastUpdated,
    required this.messages,
  });
}

class Message {
  final String id;
  final String sender;
  final Timestamp timestamp;
  final String content;

  Message({
    required this.id,
    required this.sender,
    required this.timestamp,
    required this.content,
  });
}