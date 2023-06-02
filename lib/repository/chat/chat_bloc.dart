import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learninghubapp/models/chat_model.dart';

import 'chat_state.dart';
import 'chat_event.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Assuming the current user's id is stored here
  final String currentUserId;

  ChatBloc(this.currentUserId) : super(ChatInitial()) {
    on<LoadConversations>(_loadConversations);
    on<SendMessage>(_sendMessage);
  }

  Future<void> _loadConversations(
      LoadConversations event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      // Fetch conversations from Firestore
      QuerySnapshot snapshot = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastUpdated', descending: true)
          .get();

      List<Conversation> conversations = snapshot.docs.map((doc) {
        return Conversation(
          id: doc.id,
          participants: List<String>.from(doc['participants']),
          lastMessage: doc['lastMessage'],
          lastUpdated: doc['lastUpdated'],
          messages: [],  // We are not fetching messages in this query
        );
      }).toList();

      emit(ChatLoaded(conversations));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _sendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      // Send message to Firestore
      await _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .collection('messages')
          .add({
        'sender': currentUserId,
        'timestamp': Timestamp.now(),
        'content': event.message,
      });

      // Update the lastMessage and lastUpdated fields of the conversation
      await _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .update({
        'lastMessage': event.message,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
