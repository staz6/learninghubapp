import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/chat/chat_bloc.dart';
import '../repository/chat/chat_state.dart';
import '../repository/chat/chat_event.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        
        if (state is ChatInitial) {
         
          context.read<ChatBloc>().add(LoadConversations());
          return CircularProgressIndicator();
        } else if (state is ChatLoading) {
          return CircularProgressIndicator();
        } else if (state is ChatLoaded) {
          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              // return a list tile for each conversation
              return ListTile(
                title: Text(conversation.lastMessage), 
                subtitle: Text(conversation.participants.join(', ')), 
                onTap: () {
                  
                },
              );
            },
          );
        } else if (state is ChatError) {
          return Text('Error: ${state.message}');
        } else {
          return Text('Unhandled state');
        }
      },
    );
  }
}
